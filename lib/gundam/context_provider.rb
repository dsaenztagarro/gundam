# frozen_string_literal: true

module Gundam
  class ContextProvider
    attr_writer :cli_options, :command_options

    def load_context
      CommandContext.new(base_dir, cli_options, command_options).tap do |context|
        require_relative 'context/with_repository'
        require_relative 'models/local_repository'
        context.extend(Context::WithRepository)
      end
    end

    private

    def base_dir
      cli_base_dir = cli_options[:base_dir]

      return Dir.pwd unless cli_base_dir

      raise Gundam::BaseDirNotFound, cli_base_dir unless Dir.exist?(cli_base_dir)

      cli_base_dir
    end

    def cli_options
      @cli_options ||= {}
    end

    def command_options
      @command_options ||= {}
    end
  end
end
