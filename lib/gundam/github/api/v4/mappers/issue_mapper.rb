# frozen_string_literal: true

module Gundam
  module Github
    module API
      module V4
        class IssueMapper
          # @param resource [Hash]
          def self.map(resource)
            issue = resource['data']['repository']['issue']

            assignees = issue.dig('assignees', 'edges').map do |assignee|
              assignee['node']['login']
            end

            labels = issue.dig('labels', 'edges').map do |label|
              LabelMapper.map(label['node'])
            end

            comments = issue.dig('comments', 'nodes').to_a.map do |comment|
              CommentMapper.map(comment)
            end

            Issue.new(
              body:       issue['body'],
              number:     issue['number'],
              repository: issue['repository']['nameWithOwner'],
              title:      issue['title'],
              assignees:  assignees,
              labels:     labels,
              comments:   comments
            )
          end
        end
      end
    end
  end
end
