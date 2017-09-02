module Gundam
  class CommandRunner
    attr_writer :context_provider

    # @param [Hash] opts the options to run the command with
    # @option opts [Class] :command the command to run
    def run(command:, cli_options: {}, command_options: {})
      context_provider.cli_options = cli_options
      context_provider.command_options = command_options
      context = context_provider.load_context
      command.new(context).run
    ensure
      GC.enable
    end

    def context_provider
      @context_provider ||= ContextProvider.new
    end
  end
end
