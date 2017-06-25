module Gundam
  class MissingArgument < StandardError
    def initialize(argument)
      @argument = argument
    end

    def user_message
      ::I18n.t('errors.missing_argument', argument: @argument)
    end
  end
end
