# frozen_string_literal: true

module Gundam
  # We support terminals only with 256 colors
  module ColorizeHelper
    BLUE   = 33
    CYAN   = 37
    GREEN  = 64
    ORANGE = 166
    RED    = 124
    VIOLET = 61
    YELLOW = 136

    constants.each do |constant|
      define_method constant.downcase do |text|
        ansi_color(self.class.const_get(constant), text)
      end
    end

    private

    # Sets foreground color. This is equivalent to:
    #
    # "#{`tput setaf COLOR`}#{text}"
    #
    # @param color_number [Integer] a number between [1-256]
    # @param text [String]
    def ansi_color(color_number, text)
      "\e[38;5;#{color_number}m#{text}\e[m"
    end

    def bold(text)
      "\e[0;1m#{text}\e[m"
    end
  end
end
