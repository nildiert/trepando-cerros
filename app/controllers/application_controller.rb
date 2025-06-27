class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, importmaps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, alert: 'No autorizado'
  end

  helper_method :current_athlete_id

  private

  def current_athlete_id
    session[:athlete_id]
  end

  def current_ability
    @current_ability ||= Ability.new(current_athlete_id)
  end
end
