module Gundam
  module Github
    module API
      module V4
        class CombinedStatusRefMapper
          # @param node [Hash]
          def self.map(node)
            commit_status = node['commit']['status']

            return unless commit_status

            statuses = commit_status['contexts'].map do |context|
              CommitStatus.new(
                description: context ['description'],
                state:       context ['state'],
                target_url:  context ['targetUrl']
              )
            end

            CombinedStatusRef.new(
              state: commit_status['state'],
              statuses: statuses
            )
          end
        end
      end
    end
  end
end
