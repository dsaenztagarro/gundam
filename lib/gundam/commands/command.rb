# frozen_string_literal: true

module Gundam
  class Command
    extend Forwardable

    attr_reader :context

    # @param context [CommandContext]
    def initialize(context)
      @context = context
    end
  end
end
