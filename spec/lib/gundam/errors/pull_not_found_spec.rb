# frozen_string_literal: true

require 'spec_helper'

describe Gundam::PullNotFound do
  let(:subject) { described_class.new('octocat/Hello-World', 1347) }

  describe '#user_message' do
    it 'returns the message for the user' do
      expect(subject.user_message).to \
        eq('Not found PR #1347 on octocat/Hello-World')
    end
  end
end
