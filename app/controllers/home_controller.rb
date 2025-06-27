class HomeController < ApplicationController
  def index
    if session[:strava_token] && current_athlete_id
      redirect_to athlete_path(current_athlete_id) and return
    end
  end
end
