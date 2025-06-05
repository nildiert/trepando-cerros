class DashboardController < ApplicationController
  def index
    @athlete = fetch_athlete

    return unless params[:gpx_file].present?

    analyzer = RaceAnalyzer.new(params[:gpx_file].tempfile)
    @estimated_time = analyzer.estimated_time
    flash.now[:alert] = 'No se pudo calcular el tiempo' if @estimated_time.nil?
  end

  private

  def fetch_athlete
    StravaClient.new.athlete
  rescue StandardError
    nil
  end
end
