# frozen_string_literal: true

module Gundam
  # We support terminals only with 256 colors
  # TODO: Rename to AnsiColors
  module ColorizeHelper

    # TODO: define constants
    # ORANGE = 166
    # ...

    # TODO: define methods based on existing constants

    def orange(text)
      ansi_color(166, text)
    end

    def violet(text)
      ansi_color(61, text)
    end

    def yellow(text)
      ansi_color(136, text)
    end

    def cyan(text)
      ansi_color(37, text)
    end

    def blue(text)
      ansi_color(33, text)
    end

    def green(text)
      ansi_color(64, text)
    end

    def red(text)
      ansi_color(124, text)
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
