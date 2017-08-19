module Gundam
  module Github
    module API
      module V3
        class CombinedStatusRefMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            statuses = resource[:statuses].map do |status|
              CommitStatusMapper.load(status)
            end

            CombinedStatusRef.new(
              state: resource[:state],
              statuses: statuses
            )
          end
        end
      end
    end
  end
end
