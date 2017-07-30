require 'spec_helper'

describe Gundam::IssueDecorator do
  let(:issue) { create_issue_with_comments }
  let(:subject) { described_class.new(issue) }

  describe '#show_cli' do
    it 'returns the issue formatted for console' do
      expect(subject.show_cli).to eq(
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
