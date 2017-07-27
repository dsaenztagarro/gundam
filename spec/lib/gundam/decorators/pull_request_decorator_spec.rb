require 'spec_helper'

describe Gundam::PullRequestDecorator do
  let(:issue) do
    Gundam::PullRequest.new(
      title: 'The title',
      body: 'The body of the issue',
      comments: [create_comment]
    )
  end

  let(:subject) { described_class.new(issue) }

  describe '#show_pull' do
    it 'returns the issue description' do
      expect(subject.show_pull).to eq(
        <<~END
          \e[31mThe title\e[0m
          The body of the issue
          \e[36moctokit\e[0m \e[34m2011-04-14 16:00:49 UTC\e[0m 318212279
          Me too
        END
      )
    end
  end
end
