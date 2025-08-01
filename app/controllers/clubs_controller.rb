class ClubsController < ApplicationController
  layout 'internal'
  before_action :authenticate_user

  def index
    @clubs = Club.all
  end
end
