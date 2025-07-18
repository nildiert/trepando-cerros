require 'strava/api/client'
require 'active_support/core_ext/integer/time'
require_relative 'linear_pace_model'

class StravaClient
  def initialize(access_token: ENV['STRAVA_ACCESS_TOKEN'])
    @client = Strava::Api::Client.new(access_token: access_token)
  end

  def athlete(id = nil)
    id ? @client.athlete(id) : @client.athlete
  end

  def search_athletes(query)
    if @client.respond_to?(:athletes)
      @client.athletes(search: query)
    else
      conn = Faraday.new('https://www.strava.com/api/v3')
      resp = conn.get('athletes') do |req|
        req.params[:search] = query
        req.headers['Authorization'] = "Bearer #{ENV['STRAVA_ACCESS_TOKEN']}"
      end
      data = JSON.parse(resp.body) rescue nil
      case data
      when Array
        data
      when Hash
        data['athletes'].is_a?(Array) ? data['athletes'] : []
      else
        []
      end
    end
  rescue StandardError
    []
  end

  # Returns average running pace in minutes per km from recent activities
  def average_run_pace
    paces = average_paces_by_grade
    paces.values.compact.sum / paces.size
  end

  # Returns average pace by grade category from recent activities
  def average_paces_by_grade
    after = 6.months.ago.to_i
    activities = @client.athlete_activities(after: after, per_page: 200)
    runs = activities.select { |a| a['type'] == 'Run' }
    return default_paces if runs.empty?

    totals = {
      uphill: { dist: 0.0, time: 0.0 },
      downhill: { dist: 0.0, time: 0.0 },
      flat: { dist: 0.0, time: 0.0 }
    }

    runs.each do |run|
      streams = @client.activity_streams(run['id'], keys: %w[distance time altitude], key_by_type: true)
      distances = streams['distance']
      times = streams['time']
      altitudes = streams['altitude']
      next if distances.nil? || times.nil? || altitudes.nil?

      distances.each_cons(2).with_index do |(d1, d2), idx|
        dist = d2 - d1
        next if dist <= 0
        elev = altitudes[idx + 1] - altitudes[idx]
        grade = elev / dist.to_f
        time = times[idx + 1] - times[idx]

        cat = grade_category(grade)
        totals[cat][:dist] += dist
        totals[cat][:time] += time
      end
    end

    compute_paces(totals)
  rescue StandardError
    default_paces
  end

  # Builds a simple linear model pace = a + b*grade from runs in the last year.
  # Considers only activities longer than 10 km.
  def pace_model
    after = 1.year.ago.to_i
    activities = @client.athlete_activities(after: after, per_page: 200)
    runs = activities.select { |a| a['type'] == 'Run' && a['distance'].to_f >= 10_000 }
    pairs = []

    runs.each do |run|
      streams = @client.activity_streams(run['id'], keys: %w[distance time altitude], key_by_type: true)
      d = streams['distance']
      t = streams['time']
      elev = streams['altitude']
      next if d.nil? || t.nil? || elev.nil?

      d.each_cons(2).with_index do |(d1, d2), idx|
        dist = d2 - d1
        next if dist <= 0
        grade = (elev[idx + 1] - elev[idx]) / dist.to_f
        pace = (t[idx + 1] - t[idx]) / (dist / 1000.0) / 60.0
        pairs << [grade, pace]
      end
    end

    LinearPaceModel.train(pairs)
  rescue StandardError
    nil
  end

  private

  def grade_category(grade)
    return :uphill if grade > 0.03
    return :downhill if grade < -0.03
    :flat
  end

  def compute_paces(totals)
    totals.transform_values do |data|
      if data[:dist] > 0
        km = data[:dist] / 1000.0
        min = data[:time] / 60.0
        (min / km).round(2)
      else
        nil
      end
    end.tap do |paces|
      paces.each_key { |k| paces[k] ||= default_paces[k] }
    end
  end

  def default_paces
    { uphill: 10.0, downhill: 5.0, flat: 6.0 }
  end
end
