class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, importmaps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, alert: 'No autorizado'
  end

  helper_method :current_user, :current_athlete_id

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user
    redirect_to root_path unless current_user
  end

  def current_athlete_id
    current_user&.profile&.athlete_id
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
