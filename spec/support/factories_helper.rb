module FactoriesHelper
  def create_issue
    Gundam::Issue.new(
      title: 'The title',
      body: 'The body of the issue'
    )
  end

  def create_issue_with_comments
    create_issue.tap do |issue|
      issue.comments = [create_comment]
    end
  end

  def create_pull_request
    Gundam::PullRequest.new(
      title: 'The title',
      body: 'The body of the issue',
      html_url: 'https://github.com/octocat/Hello-World/pull/1347',
      comments: [create_comment]
    )
  end

  def create_comment
    Gundam::IssueComment.new(
      id: 318212279,
      author: 'octokit',
      created_at: Time.parse('2011-04-14T12:30:24Z'),
      updated_at: Time.parse('2011-04-14T16:00:49Z'),
      body: 'Me too'
    )
  end
end

RSpec.configure do |config|
  config.include FactoriesHelper
end
