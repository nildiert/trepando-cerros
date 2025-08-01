module Clubs
  class NewButtonComponent < ViewComponent::Base
    def call
      return unless helpers.can? :manage, Club

      link_to 'Nuevo Club', helpers.new_club_path, class: 'btn btn-primary mb-4'
    end
  end
end
