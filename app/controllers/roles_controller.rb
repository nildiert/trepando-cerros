class RolesController < ApplicationController
  before_action :authenticate_user
  before_action :set_role, only: [:show, :update]

  def show
    authorize! :manage, :settings
    @permissions = available_permissions
    render layout: false if turbo_frame_request?
  end

  def update
    authorize! :manage, :settings
    available_permissions.each do |name|
      perm = @role.role_permissions.find_or_initialize_by(name: name)
      perm.enabled = params[name] == '1'
      perm.save!
    end
    @permissions = available_permissions
    if turbo_frame_request?
      render :show, layout: false
    else
      redirect_to role_path(@role), notice: 'Perfil actualizado'
    end
  end

  def create
    authorize! :manage, :settings
    @role = Role.new(role_params)
    if @role.save
      redirect_to settings_path, notice: 'Perfil creado'
    else
      redirect_to settings_path, alert: 'No se pudo crear el perfil'
    end
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def available_permissions
    %w[race_predictor training_plan]
  end

  def role_params
    params.require(:role).permit(:name)
  end
end
