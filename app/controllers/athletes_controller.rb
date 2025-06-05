class AthletesController < ApplicationController
  def show
    @athlete = fetch_athlete(params[:id])
    unless @athlete
      flash.now[:alert] = 'No se pudo cargar la información de Strava.'
      return
    end

    return unless params[:gpx_file].present?

    token = session[:strava_token] || ENV['STRAVA_ACCESS_TOKEN']
    analyzer = RaceAnalyzer.new(params[:gpx_file].tempfile, strava_client: StravaClient.new(access_token: token))
    result = analyzer.analyze
    if result
      @estimated_time = result[:time]
      @profile_data = result[:profile]
      @hourly_progress = result[:progress]
    else
      flash.now[:alert] = 'No se pudo calcular el tiempo'
    end
  end

  private

  def fetch_athlete(id = nil)
    token = session[:strava_token] || ENV['STRAVA_ACCESS_TOKEN']
    client = StravaClient.new(access_token: token)
    id ? client.athlete(id) : client.athlete
  rescue StandardError
    nil
  end
end
