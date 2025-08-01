module Ui
  class ButtonComponent < ViewComponent::Base
    def initialize(href: nil, method: nil, classes: 'btn btn-primary')
      @href = href
      @method = method
      @classes = classes
    end

    def call
      if @href
        link_to content, @href, method: @method, class: @classes
      else
        content_tag :button, content, type: 'button', class: @classes
      end
    end
  end
end
