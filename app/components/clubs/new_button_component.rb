module Clubs
  class NewButtonComponent < ViewComponent::Base
    def call
      return unless helpers.can? :manage, Club

      render Ui::ButtonComponent.new(href: helpers.new_club_path, classes: 'mb-4') do
        'Nuevo Club'
      end
    end
  end
end
