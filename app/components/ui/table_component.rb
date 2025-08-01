module Ui
  class TableComponent < ViewComponent::Base
    def initialize(headers:)
      @headers = headers
    end
  end
end
