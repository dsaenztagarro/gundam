module Gundam
  class CliOptionError < ArgumentError
    def initialize(cli_option)
      @cli_option = cli_option
    end

    def user_message
      "Missing cli option #{@cli_option}"
    end
  end
end
