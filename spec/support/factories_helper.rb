module FactoriesHelper
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
