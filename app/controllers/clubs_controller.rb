class ClubsController < ApplicationController
  layout 'internal'
  before_action :authenticate_user

  def index
    @clubs = Club.all
  end

  def new
    authorize! :manage, Club
    @club = Club.new
  end

  def create
    authorize! :manage, Club
    @club = Club.new(club_params)
    if @club.save
      redirect_to clubs_path, notice: 'Club creado'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def club_params
    params.require(:club).permit(:name, :description)
  end
end
