# frozen_string_literal: true

module Gundam
  class ErrorHandler
    class << self
      # @params error [StandardError]
      def handle(error)
        message = if error.respond_to?(:user_message)
                    error.user_message
                  elsif error.cause
                    error.cause.message
                  else
                    error.message
                  end

        puts Gundam.theme.as_error("ERROR:\n#{message}\n\nBACKTRACE:\n#{error.backtrace && error.backtrace.join("\n")}") if message
      end
    end
  end
end
