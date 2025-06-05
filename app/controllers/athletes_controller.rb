class AthletesController < ApplicationController
  def show
    @athlete = fetch_athlete(params[:id])
    return unless params[:gpx_file].present?

    analyzer = RaceAnalyzer.new(params[:gpx_file].tempfile)
    result = analyzer.analyze
    if result
      @estimated_time = result[:time]
      @profile_data = result[:profile]
      @hourly_progress = result[:progress]
    else
      flash.now[:alert] = 'No se pudo calcular el tiempo'
    end
  end

  def search
    results = search_athletes(params[:query])
    athletes = Array(results).map do |a|
      {
        id: a['id'] || a[:id],
        firstname: a['firstname'] || a[:firstname],
        lastname: a['lastname'] || a[:lastname],
        profile: a['profile'] || a[:profile]
      }
    end
    render json: athletes
  end

  private

  def fetch_athlete(id = nil)
    client = StravaClient.new
    id ? client.athlete(id) : client.athlete
  rescue StandardError
    nil
  end

  def search_athletes(query)
    client = StravaClient.new
    client.search_athletes(query)
  rescue StandardError
    []
  end
end
