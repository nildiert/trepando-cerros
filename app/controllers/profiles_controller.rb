class ProfilesController < ApplicationController
  layout 'internal'
  before_action :authenticate_user
  before_action :set_user

  def show
    authorize! :manage, :athletes
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
