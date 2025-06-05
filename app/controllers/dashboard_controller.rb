class DashboardController < ApplicationController
  def index
    @athlete = fetch_athlete

    if params[:gpx_file].present?
      analyzer = RaceAnalyzer.new(params[:gpx_file].tempfile)
      @estimated_time = analyzer.estimated_time
    elsif params[:distance].present? && params[:pace].present?
      calculator = RaceTimeCalculator.new(params[:distance].to_f, params[:pace].to_f)
      @estimated_time = calculator.formatted_time
    end
  end

  private

  def fetch_athlete
    StravaClient.new.athlete
  rescue StandardError
    nil
  end
end
