class SettingsController < ApplicationController
  before_action :authenticate_user

  def show
    authorize! :manage, :settings
    @features = session[:features] || { race_predictor: true }
  end

  def update
    authorize! :manage, :settings
    session[:features] = {
      race_predictor: params[:race_predictor] == '1'
    }
    redirect_to settings_path, notice: 'Configuraci\u00f3n actualizada'
  end

  private

  def authenticate_user
    redirect_to root_path unless session[:athlete_id]
  end
end
