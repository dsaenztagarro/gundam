# frozen_string_literal: true

module Gundam
  module Github
    module API
      module V3
        class TeamMemberMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::TeamMember.new(
              id:  resource[:id],
              login: resource[:login]
            )
          end
        end
      end
    end
  end
end
