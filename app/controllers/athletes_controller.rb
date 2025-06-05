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

  def lookup
    athlete = fetch_athlete(params[:query])
    if athlete
      render json: { id: athlete.id, firstname: athlete.firstname, lastname: athlete.lastname, profile: athlete.profile }
    else
      render json: {}, status: :not_found
    end
  end

  private

  def fetch_athlete(id = nil)
    client = StravaClient.new
    if id
      client.athlete(id)
    else
      client.athlete
    end
  rescue StandardError
    nil
  end
end
