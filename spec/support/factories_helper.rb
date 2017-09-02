# frozen_string_literal: true

module Gundam
  module FactoriesHelper
    def create_issue
      Issue.new(
        assignees: %w[octocat],
        body: "I'm having a problem with this.",
        html_url: 'https://github.com/octocat/Hello-World/issues/1347',
        labels: [create_label, create_label(id: 208_045_947, name: 'support')],
        number: 1347,
        title: 'Found a bug'
      )
    end

    def create_label(id: nil, name: nil)
      Label.new(id: id || 208_045_946, color: 'f29513', name: name || 'bug')
    end

    def create_issue_with_comments
      create_issue.tap do |issue|
        issue.comments = [create_comment]
      end
    end

    def create_pull
      Pull.new(
        number: 1347,
        title: 'new-feature',
        body: 'Please pull these awesome changes',
        state: 'open',
        html_url: 'https://github.com/octocat/Hello-World/pull/1347'
      )
    end

    def create_pull_expanded
      create_pull.tap do |pull|
        pull.comments = [create_comment]
        pull.combined_status = create_combined_status
      end
    end

    def create_combined_status
      statuses = [
        create_commit_status,
        create_commit_status(
          context: 'security/brakeman',
          description: 'Testing has completed successfully',
          target_url: 'https://ci.example.com/2000/output'
        )
      ]
      CombinedStatusRef.new(state: 'success', statuses: statuses)
    end

    def create_commit_status(options = {})
      CommitStatus.new(
        context: options[:context] || 'continuous-integration/jenkins',
        description: options[:description] || 'Build has completed successfully',
        state: 'success',
        updated_at: '2012-07-20T01:19:13Z',
        target_url: options[:target_url] || 'https://ci.example.com/1000/output'
      )
    end

    def create_comment
      Comment.new(
        id: 318_212_279,
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
