module Gundam
  module FactoriesHelper
    def create_issue
      Issue.new(
        assignee: 'octocat',
        body: "I'm having a problem with this.",
        html_url: 'https://github.com/octocat/Hello-World/issues/1347',
        labels: [ create_label, create_label(id: 208045947, name: 'support') ],
        number: 1347,
        title: 'Found a bug'
      )
    end

    def create_label(id: nil, name: nil)
      Label.new(id: id || 208045946, color: 'f29513', name: name || 'bug')
    end

    def create_issue_with_comments
      create_issue.tap do |issue|
        issue.comments = [create_comment]
      end
    end

    def create_pull_request
      PullRequest.new(
        number: 1347,
        title: 'new-feature',
        body: 'Please pull these awesome changes',
        state: 'open',
        html_url: 'https://github.com/octocat/Hello-World/pull/1347',
        comments: [create_comment]
      )
    end

    def create_comment
      IssueComment.new(
        id: 318212279,
        author: 'octokit',
        created_at: Time.parse('2011-04-14T12:30:24Z'),
        updated_at: Time.parse('2011-04-14T16:00:49Z'),
        body: 'Me too'
      )
    end
  end
end

RSpec.configure do |config|
  config.include Gundam::FactoriesHelper
end
