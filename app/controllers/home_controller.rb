class HomeController < ApplicationController
  def index
    if session[:strava_token] && session[:athlete_id]
      redirect_to athlete_path(session[:athlete_id]) and return
    end
  end
end
