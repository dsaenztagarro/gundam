module Gundam
  class CommandContext
    attr_reader :base_dir, :cli_options

    def initialize(base_dir, cli_options)
      @base_dir    = base_dir
      @cli_options = cli_options
    end
  end
end
