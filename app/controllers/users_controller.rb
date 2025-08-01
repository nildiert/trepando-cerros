class UsersController < ApplicationController
  before_action :authenticate_user
  before_action :set_user, only: [:edit, :update, :show]

  def index
    authorize! :manage, :settings
    @users = User.includes(:role)
    @roles = Role.all
    @permissions = RolePermission::AVAILABLE_PERMISSIONS
  end

  def edit
    authorize! :manage, :settings
    @roles = Role.all
    @permissions = RolePermission::AVAILABLE_PERMISSIONS
  end

  def update
    authorize! :manage, :settings
    @roles = Role.all
    @permissions = RolePermission::AVAILABLE_PERMISSIONS
    @permissions.each do |name|
      perm = @user.permissions.find_or_initialize_by(name: name)
      perm.enabled = params[name] == '1'
      perm.save!
    end
    if @user.update(user_params)
      redirect_to settings_path, notice: 'Usuario actualizado'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    authorize! :manage, :athletes
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role_id)
  end
end
