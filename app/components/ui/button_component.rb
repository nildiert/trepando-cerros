module Ui
  class ButtonComponent < ViewComponent::Base
    def initialize(href: nil, method: nil, classes: '')
      @href = href
      @method = method
      @classes = classes
    end

    def call
      base = 'btn text-white bg-[#5E81AC] hover:bg-[#4c6b90] border-none'
      final_classes = [base, @classes].reject(&:blank?).join(' ')
      if @href
        link_to content, @href, method: @method, class: final_classes
      else
        content_tag :button, content, type: 'button', class: final_classes
      end
    end
  end
end
