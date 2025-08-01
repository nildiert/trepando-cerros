module Clubs
  class FormComponent < ViewComponent::Base
    def initialize(club:)
      @club = club
    end
  end
end
