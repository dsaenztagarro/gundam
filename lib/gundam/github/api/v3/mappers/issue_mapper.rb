# frozen_string_literal: true

module Gundam
  module Github
    module API
      module V3
        class IssueMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            assignee = (resource[:assignee] || {})[:login]
            assignees = assignee ? [assignee] : []

            Issue.new(
              html_url: resource[:html_url],
              assignees: assignees,
              body:     resource[:body],
              labels:   resource[:labels].map { |lab| LabelMapper.load(lab) },
              number:   resource[:number],
              title:    resource[:title]
            )
          end
        end
      end
    end
  end
end
