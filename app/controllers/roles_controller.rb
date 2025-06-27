class RolesController < ApplicationController
  before_action :set_role

  def show
    authorize! :manage, :settings
    @permissions = available_permissions
  end

  def update
    authorize! :manage, :settings
    available_permissions.each do |name|
      perm = @role.role_permissions.find_or_initialize_by(name: name)
      perm.enabled = params[name] == '1'
      perm.save!
    end
    redirect_to role_path(@role), notice: 'Perfil actualizado'
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def available_permissions
    %w[race_predictor]
  end
end
