# frozen_string_literal: true

module Gundam
  class CommandRunner
    attr_writer :context_provider

    def initialize(commands)
      @registered_commands = commands
    end

    # @param [Hash] opts the options to run the command with
    # @option opts [Class] :command the command to run
    def run(command_key:, cli_options: {}, command_options: {})
      context_provider.cli_options = cli_options
      context_provider.command_options = command_options
      context = context_provider.load_context
      load_command(command_key, context)
    rescue => error
      Gundam::ErrorHandler.handle(error)
    ensure
      GC.enable
    end

    def load_command(command_key, context)
      raise "Unregistered command" unless registered?(command_key)
      command_class_for(command_key).new(context).run
    end

    def context_provider
      @context_provider ||= ContextProvider.new
    end

    private

    def registered?(command_key)
      @registered_commands.include?(command_key)
    end

    def command_class_for(command_key)
      command_path = command_key.gsub(':', '/')
      class_name = @registered_commands[command_key]

      require_relative "commands/#{command_path}"
      Kernel.const_get(class_name)
    end
  end
end
