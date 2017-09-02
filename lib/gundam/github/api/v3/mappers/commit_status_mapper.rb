# frozen_string_literal: true

module Gundam
  module Github
    module API
      module V3
        class CommitStatusMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::CommitStatus.new(
              context:     resource[:context],
              created_at:  resource[:created_at],
              description: resource[:description],
              state:       resource[:state],
              target_url:  resource[:target_url],
              updated_at:  resource[:updated_at]
            )
          end
        end
      end
    end
  end
end
