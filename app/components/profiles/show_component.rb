module Profiles
  class ShowComponent < ViewComponent::Base
    def initialize(user:)
      @user = user
    end
  end
end
