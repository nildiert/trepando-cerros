class DashboardController < ApplicationController
  def index
    @athlete = fetch_athlete

    if params[:distance].present? && params[:pace].present?
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
