require_relative '../helpers/colorize_helper'

module Gundam
  class ErrorHandler
    class << self
      include ColorizeHelper

      # @params error [StandardError]
      def handle(error)
        if error.respond_to? :user_message
          puts red(error.user_message)
        end
      end
    end
  end
end
