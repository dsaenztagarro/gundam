require 'spec_helper'

describe Gundam::Unauthorized do
  describe '#user_message' do
    it 'returns the message for :github_api_v4' do
      subject = described_class.new(:github_api_v4)
      expect(subject.user_message).to \
        eq('Unauthorized access to Github GraphQL API V4')
    end
  end
end
