# frozen_string_literal: true

module Gundam
  class TestTheme
    include TimeHelper

    TAGS = %i[title user date id uri error content error success].freeze

    TAGS.each do |tag|
      define_method "as_#{tag}" do |text|
        "<#{tag}>#{text}</#{tag}>"
      end
    end

    def as_date(date)
      "<date>#{date.strftime('%d/%m/%Y %H:%M')}</date>"
    end
  end
end
