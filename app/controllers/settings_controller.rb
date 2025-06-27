class SettingsController < ApplicationController
  before_action :authenticate_user
  before_action :set_athlete

  def show
    authorize! :manage, :settings
    @race_predictor = current_user.permissions.find_or_initialize_by(name: 'race_predictor')
  end

  def update
    authorize! :manage, :settings
    perm = current_user.permissions.find_or_initialize_by(name: 'race_predictor')
    perm.enabled = params[:race_predictor] == '1'
    perm.save!
    redirect_to athlete_settings_path(@athlete), notice: 'Configuraci\u00f3n actualizada'
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
