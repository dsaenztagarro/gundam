# frozen_string_literal: true

module Gundam
  class ErrorHandler
    class << self
      # @params error [StandardError]
      def handle(error)
        message = if error.is_a?(Gundam::Error)
                    "ERROR:\n#{error.message}\n"
                  else
                    "ERROR:\n#{error.message}\n\nBACKTRACE:\n#{error.backtrace&.join("\n")}"
                  end

        puts Gundam.theme.as_error(message)
      end
    end
  end
end
