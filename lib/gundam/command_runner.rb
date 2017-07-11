module Gundam
  class CommandRunner
    attr_writer :context_provider

    def run(command:, cli_options: {})
      context_provider.cli_options = cli_options
      context = context_provider.load_context
      command.new(context).run
    end

    def context_provider
      @context_provider ||= ContextProvider.new
    end
  end
end
