module Gundam
  module Github
    module API
      module V3
        class TeamMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::Team.new(
              id:  resource[:id],
              name: resource[:name]
            )
          end
        end
      end
    end
  end
end

