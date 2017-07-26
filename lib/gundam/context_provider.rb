module Gundam
  class ContextProvider
    attr_writer :cli_options

    def load_context
      CommandContext.new(base_dir, cli_options).tap do |context|
        context.extend(Context::WithRepository)
      end
    end

    private

    def base_dir
      cli_base_dir = cli_options[:base_dir]

      return Dir.pwd unless cli_base_dir

      unless Dir.exist?(cli_base_dir)
        raise Gundam::BaseDirNotFound.new(cli_base_dir)
      end

      cli_base_dir
    end

    def cli_options
      @cli_options ||= {}
    end
  end
end
