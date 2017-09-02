# frozen_string_literal: true

module Gundam
  class Team
    attr_reader :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end
  end
end
