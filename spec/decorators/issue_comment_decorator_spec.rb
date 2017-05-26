require 'spec_helper'

describe IssueCommentDecorator do
  let(:issue_comment) do
    IssueComment.new(
      user_login: 'octokit',
      created_at: Date.parse('2010-10-28'),
      updated_at: Date.parse('2010-11-15'),
      body: 'The body of the comment'
    )
  end

  let(:subject) { described_class.new(issue_comment) }

  describe '#to_s' do
    it 'returns the issue comment formatted to console output' do
      expect(subject.to_s).to eq(
        <<~END
        \e[36moctokit\e[0m \e[34m2010-11-15\e[0m
        The body of the comment
        END
      )
    end
  end
end
