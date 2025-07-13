class TrainingsController < ApplicationController
  before_action :authenticate_user
  before_action :set_athlete

  def show
    @week_start = Date.current.beginning_of_week
    @messages = random_messages(7)
  end

  private

  def set_athlete
    @athlete = fetch_athlete(params[:athlete_id])
  end

  def fetch_athlete(id = nil)
    token = session[:strava_token] || ENV['STRAVA_ACCESS_TOKEN']
    client = StravaClient.new(access_token: token)
    if id.present? && current_athlete_id.present? && id.to_s != current_athlete_id.to_s
      client.athlete(id)
    else
      client.athlete
    end
  rescue StandardError
    nil
  end

  def random_messages(count)
    samples = [
      "Sesión de fuerza y resistencia.",
      "Rodaje suave por la ciudad.",
      "Entrenamiento de velocidad en pista.",
      "Día de descanso y estiramientos.",
      "Trabajos de técnica de carrera.",
      "Entrenamiento cruzado con bicicleta.",
      "Series en subida de intensidad moderada.",
      "Sesión de recuperación activa.",
      "Rodaje por terreno montañoso." 
    ]
    samples.shuffle.take(count)
  end
end
