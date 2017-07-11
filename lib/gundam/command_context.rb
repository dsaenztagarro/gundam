module Gundam
  class CommandContext
    attr_reader :repository, :number, :service, :original_options

    def initialize(options = {})
      @original_options = options[:original_options]
      @repository       = options[:repository]
      @number           = options[:number]
      @service          = options[:service]
    end
  end
end
