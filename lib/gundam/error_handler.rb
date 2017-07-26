require_relative '../helpers/colorize_helper'

module Gundam
  class ErrorHandler
    class << self
      include ColorizeHelper

      # @params error [StandardError]
      def handle(error)
        puts red(error.user_message) if error.respond_to? :user_message
      end
    end
  end
end
