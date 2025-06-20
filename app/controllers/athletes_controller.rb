class AthletesController < ApplicationController
  def show
    @athlete = fetch_athlete(params[:id])
    unless @athlete
      flash.now[:alert] = 'No se pudo cargar la información de Strava.'
      return
    end

    @start_time = params[:start_time]

    return unless params[:gpx_file].present?

    token = session[:strava_token] || ENV['STRAVA_ACCESS_TOKEN']
    analyzer = RaceAnalyzer.new(params[:gpx_file].tempfile, strava_client: StravaClient.new(access_token: token))
    result = analyzer.analyze
    if result
      @estimated_time = result[:time]
      @profile_data = result[:profile]
      @hourly_progress = result[:progress]
      @km_seconds = result[:km_seconds]
      @total_distance = result[:distance]
      @total_elevation = result[:elevation]
    else
      flash.now[:alert] = 'No se pudo calcular el tiempo'
    end
  end

  def nutrition
    plan = NutritionPlan.new(start_time: params[:start_time])
    send_data plan.pdf, filename: "plan_nutricional.pdf", type: "application/pdf"
  end

  private

  def fetch_athlete(id = nil)
    token = session[:strava_token] || ENV['STRAVA_ACCESS_TOKEN']
    client = StravaClient.new(access_token: token)
    if id.present? && session[:athlete_id].present? && id.to_s != session[:athlete_id].to_s
      client.athlete(id)
    else
      client.athlete
    end
  rescue StandardError
    nil
  end
end
