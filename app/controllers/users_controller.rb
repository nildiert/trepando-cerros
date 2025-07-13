class UsersController < ApplicationController
  before_action :authenticate_user
  before_action :set_user, only: [:edit, :update]

  def index
    authorize! :manage, :settings
    @users = User.includes(:role)
  end

  def edit
    authorize! :manage, :settings
    @roles = Role.all
  end

  def update
    authorize! :manage, :settings
    @roles = Role.all
    if @user.update(user_params)
      redirect_to settings_path, notice: 'Usuario actualizado'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role_id)
  end
end
