require 'spec_helper'

describe Gundam::IssueDecorator do
  let(:issue)   { create_issue_with_comments }
  let(:subject) { described_class.new(issue) }

  describe '#string' do
    it 'returns the issue formatted for console' do
      expect(subject.string).to eq(
        <<~END
          \e[31mFound a bug\e[0m
          I'm having a problem with this.
          \e[36moctokit\e[0m \e[34m2011-04-14 16:00:49 UTC\e[0m 318212279
          Me too
        END
      )
    end
  end
end
