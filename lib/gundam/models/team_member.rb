# frozen_string_literal: true

module Gundam
  class TeamMember
    attr_reader :id, :login

    def initialize(id:, login:)
      @id = id
      @login = login
    end
  end
end
