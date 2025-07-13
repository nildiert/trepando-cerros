class HomeController < ApplicationController
  def index
    redirect_to dashboard_path and return if current_user
  end
end
