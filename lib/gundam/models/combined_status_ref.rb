# frozen_string_literal: true

module Gundam
  class CombinedStatusRef
    attr_accessor :state, :statuses

    def initialize(state:, statuses:)
      @state = state
      @statuses = statuses
    end
  end
end
