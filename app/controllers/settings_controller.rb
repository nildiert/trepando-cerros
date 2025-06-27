class SettingsController < ApplicationController
  before_action :authenticate_user

  def show
    authorize! :manage, :settings
    @race_predictor = current_user.permissions.find_or_initialize_by(name: 'race_predictor')
  end

  def update
    authorize! :manage, :settings
    perm = current_user.permissions.find_or_initialize_by(name: 'race_predictor')
    perm.enabled = params[:race_predictor] == '1'
    perm.save!
    redirect_to settings_path, notice: 'Configuraci\u00f3n actualizada'
  end

  private

  def authenticate_user
    redirect_to root_path unless session[:user_id]
  end
end
