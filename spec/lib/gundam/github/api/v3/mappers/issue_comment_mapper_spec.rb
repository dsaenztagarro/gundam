# frozen_string_literal: true

require 'spec_helper'

describe Gundam::Github::API::V3::CommentMapper do
  let(:resource) { github_api_v3_response(:get_issue_comments).first }

  describe '.load' do
    it 'returns the expected instance' do
      object = described_class.load(resource)

      expect(object).to be_a(Gundam::Comment)
      expect(object.author).to eq('octocat')
      expect(object.body).to eq('Me too')
      expect(object.created_at).to eq('2011-04-14T16:00:49Z')
      expect(object.updated_at).to eq('2011-04-14T16:00:49Z')
    end
  end
end
