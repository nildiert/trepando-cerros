class TrainingsController < ApplicationController
  before_action :authenticate_user
  before_action :set_athlete

  def show
  end

  private

  def authenticate_user
    redirect_to root_path unless session[:user_id]
  end

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
end
