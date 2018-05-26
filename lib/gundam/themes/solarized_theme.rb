# frozen_string_literal: true

module Gundam
  class SolarizedTheme
    include ColorizeHelper
    include TimeHelper
    include TextHelper

    def initialize(options = {})
      @options = options
    end

    def as_title(text)
      bold(green(text))
    end

    def as_user(text)
      bold(orange(text))
    end

    def as_date(date)
      formatted_date = with_time_zone(current_time_zone) do
        date.getlocal.strftime('%d/%m/%Y %H:%M')
      end

      bold(yellow(formatted_date))
    end

    def as_id(text)
      bold(violet(text))
    end

    def as_uri(text)
      green(text)
    end

    def as_success(text)
      green(text)
    end

    def as_error(text)
      red(text)
    end

    def as_content(text)
      if @options[:wrapped_content]
        reformat_wrapped(text)
      else
        text
      end
    end
  end
end
