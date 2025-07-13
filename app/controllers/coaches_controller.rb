class CoachesController < ApplicationController
  before_action :authenticate_user
  before_action :set_athlete
  before_action :authorize_admin, only: [:index]

  def index
    if current_user.club
      @coaches = current_user.club.users.joins(:role).where(roles: { name: 'trainer' })
    else
      @coaches = User.joins(:role).where(roles: { name: 'trainer' })
    end
  end

  private

  def authorize_admin
    authorize! :manage, User
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
