# frozen_string_literal: true

require 'spec_helper'

describe Gundam::IssueDecorator do
  let(:issue)   { create_issue_with_comments }
  let(:subject) { described_class.new(issue) }

  describe '#to_stdout' do
    it 'returns the issue formatted for console' do
      expect(subject.to_stdout).to eq(
        <<~OUTPUT
          <title>Found a bug</title>
          <content>I'm having a problem with this.</content>
          <user>octokit</user> <date>14/04/2011 16:00</date> <id>318212279</id>
          <content>Me too</content>
        OUTPUT
      )
    end
  end
end
