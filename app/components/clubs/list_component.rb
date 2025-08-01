module Clubs
  class ListComponent < ViewComponent::Base
    def initialize(clubs:)
      @clubs = clubs
    end
  end
end
