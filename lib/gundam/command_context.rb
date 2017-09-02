# frozen_string_literal: true

module Gundam
  class CommandContext
    attr_reader :base_dir, :cli_options, :command_options

    def initialize(base_dir, cli_options, command_options)
      @base_dir    = base_dir
      @cli_options = cli_options
      @command_options = command_options
    end
  end
end
