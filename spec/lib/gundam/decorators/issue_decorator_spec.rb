require 'spec_helper'

describe Gundam::IssueDecorator do
  let(:issue) do
    Issue.new(
      title: 'The title',
      body: 'The body of the issue',
      comments: [
        IssueComment.new(
          user_login: 'octokit',
          created_at: Date.parse('2010-10-28'),
          updated_at: Date.parse('2010-11-15'),
          body: 'The body of the comment'
        ),
        IssueComment.new(
          user_login: 'octokit',
          created_at: Date.parse('2010-10-28'),
          updated_at: Date.parse('2010-11-15'),
          body: 'The second comment'
        )
      ]
    )
  end

  let(:subject) { described_class.new(issue) }

  describe '#show_issue' do
    let(:result) { subject.show_issue(options) }

    context 'with description' do
      let(:options) do { with_description: true } end

      it 'returns the issue description' do
        expect(result).to eq(
          <<~END
          \e[31mThe title\e[0m
          The body of the issue
          END
        )
      end
    end

    context 'with comments' do
      let(:options) do { with_comments: true } end

      it 'returns the issue comments' do
        expect(result).to eq(
          <<~END
          \e[36moctokit\e[0m \e[34m2010-11-15\e[0m
          The body of the comment
          \e[36moctokit\e[0m \e[34m2010-11-15\e[0m
          The second comment
          END
        )
      end
    end
  end
end
