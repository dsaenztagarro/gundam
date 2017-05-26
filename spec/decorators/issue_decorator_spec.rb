require 'spec_helper'

describe IssueDecorator do
  let(:issue) { Issue.new title: 'The title', body: 'The body of the issue' }
  let(:subject) { described_class.new(issue) }

  describe '#to_s' do
    it 'returns the issue formatted to console output' do
      expect(subject.to_s).to eq(
        <<~END
        \e[31mThe title\e[0m
        The body of the issue
        END
      )
    end
  end
end
