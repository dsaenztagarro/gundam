module Gundam
  class CommandContext
    attr_reader :repository, :number, :service

    def initialize(repository:, number:, service:)
      @repository = repository
      @number = number
      @service = service
    end
  end
end
