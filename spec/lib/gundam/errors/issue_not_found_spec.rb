# frozen_string_literal: true

require 'spec_helper'

describe Gundam::IssueNotFound do
  let(:subject) { described_class.new('octocat/Hello-World', 1347) }

  describe '#user_message' do
    it 'returns the message for the user' do
      expect(subject.user_message).to \
        eq('Not found issue #1347 on octocat/Hello-World')
    end
  end
end
