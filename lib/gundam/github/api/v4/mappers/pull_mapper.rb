# frozen_string_literal: true

module Gundam
  module Github
    module API
      module V4
        class PullMapper
          # @param node [Hash]
          def self.map(node)
            comments = node.dig('comments', 'nodes').to_a.map do |comment|
              CommentMapper.map(comment)
            end

            combined_status = node.dig('commits', 'nodes').to_a.map do |node|
              CombinedStatusRefMapper.map(node)
            end.first

            Pull.new(
              number:   node['number'],
              title:    node['title'],
              body:     node['body'],
              comments: comments,
              combined_status: combined_status
            )
          end

          def self.wrap(response)
            pulls = response.dig('data', 'repository', 'pullRequests', 'edges')
            pulls.map { |pull| map(pull['node']) }
          end
        end
      end
    end
  end
end
