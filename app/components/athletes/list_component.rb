module Athletes
  class ListComponent < ViewComponent::Base
    def initialize(athletes:, club: nil)
      @athletes = athletes
      @club = club
    end
  end
end
