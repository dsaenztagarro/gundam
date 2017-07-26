module Gundam
  class CliOptionError < ArgumentError
    def initialize(cli_option)
      @cli_option = cli_option
    end

    def user_message
      ::I18n.t('errors.cli_option_missing', cli_option: @cli_option)
    end
  end
end
