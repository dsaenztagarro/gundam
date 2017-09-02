# frozen_string_literal: true

require 'spec_helper'

describe Gundam::Github::API::V3::IssueMapper do
  let(:resource) { github_api_v3_response :get_issue }

  describe '#to_h' do
    it 'returns the expected instance' do
      object = described_class.load(resource)

      expect(object).to be_a(Gundam::Issue)
      expect(object.assignees).to eq(%w[octocat])
      expect(object.body).to eq("I'm having a problem with this.")
      expect(object.number).to eq(1347)
      expect(object.title).to eq('Found a bug')
    end
  end
end
