module Gundam
  class Unauthorized < StandardError
    def initialize(gateway, options = {})
      @gateway = gateway
      @options = options
    end

    def user_message
      ::I18n.t("errors.unauthorized_#{@gateway}", @options)
    end
  end
end
