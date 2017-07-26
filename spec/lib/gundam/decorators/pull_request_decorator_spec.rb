require 'spec_helper'

describe Gundam::PullRequestDecorator do
  let(:issue) do
    Gundam::PullRequest.new(
      title: 'The title',
      body: 'The body of the issue',
      comments: [
        Gundam::IssueComment.new(
          author: 'octokit',
          created_at: Date.parse('2010-10-28'),
          updated_at: Date.parse('2010-11-15'),
          body: 'The body of the comment'
        ),
        Gundam::IssueComment.new(
          author: 'octokit',
          created_at: Date.parse('2010-10-28'),
          updated_at: Date.parse('2010-11-15'),
          body: 'The second comment'
        )
      ]
    )
  end

  let(:subject) { described_class.new(issue) }

  describe '#show_pull' do
    it 'returns the issue description' do
      expect(subject.show_pull).to eq(
        <<~END
        \e[31mThe title\e[0m
        The body of the issue
        \e[36moctokit\e[0m \e[34m2010-11-15\e[0m
        The body of the comment
        \e[36moctokit\e[0m \e[34m2010-11-15\e[0m
        The second comment
        END
      )
    end
  end
end
