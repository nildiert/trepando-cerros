module Users
  class ListComponent < ViewComponent::Base
    def initialize(users:, roles: nil)
      @users = users
      @roles = roles
    end
  end
end
