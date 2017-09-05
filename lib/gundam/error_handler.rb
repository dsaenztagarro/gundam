# frozen_string_literal: true

module Gundam
  class ErrorHandler
    class << self
      include ColorizeHelper

      # @params error [StandardError]
      def handle(error)
        message = if error.respond_to?(:user_message)
                    error.user_message
                  elsif error.cause
                    error.cause.message
                  else
                    error.message
                  end

        puts red(message) if message
      end
    end
  end
end
