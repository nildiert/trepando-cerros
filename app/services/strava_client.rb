require 'strava/api/client'

class StravaClient
  def initialize(access_token: ENV['STRAVA_ACCESS_TOKEN'])
    @client = Strava::Api::Client.new(access_token: access_token)
  end

  def athlete
    @client.athlete
  end

  # Returns average running pace in minutes per km from recent activities
  def average_run_pace
    activities = @client.athlete_activities(per_page: 30)
    runs = activities.select { |a| a['type'] == 'Run' }
    return 6.0 if runs.empty?

    total_distance_km = runs.sum { |a| a['distance'].to_f } / 1000.0
    total_time_min = runs.sum { |a| a['moving_time'].to_f } / 60.0
    (total_time_min / total_distance_km).round(2)
  rescue StandardError
    6.0
  end
end
