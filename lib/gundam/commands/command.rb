module Gundam
  class Command
    extend Forwardable

    attr_reader :context

    # @param context [CommandContext]
    def initialize(context)
      @context = context
    end

    def default_profile
      Profiles::Bebanjo::Configuration.new
    end
  end
end
