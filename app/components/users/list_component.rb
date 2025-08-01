module Users
  class ListComponent < ViewComponent::Base
    def initialize(users:, roles: nil, permissions: RolePermission::AVAILABLE_PERMISSIONS)
      @users = users
      @roles = roles
      @permissions = permissions
    end
  end
end
