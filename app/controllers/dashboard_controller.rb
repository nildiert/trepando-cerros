class DashboardController < ApplicationController
  def index
    @athlete = fetch_athlete

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

  private

  def fetch_athlete
    StravaClient.new.athlete
  rescue StandardError
    nil
  end
end
