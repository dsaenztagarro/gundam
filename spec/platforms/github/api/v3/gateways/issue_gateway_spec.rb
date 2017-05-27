require 'spec_helper'

describe Platforms::Github::API::V3::IssueGateway do
  let(:resource) { github_api_v3_response :get_issue }
  let(:subject)  { described_class.new(resource) }

  describe '#to_h' do
    it 'returns true' do
      expect(subject.to_h).to eq({
        title: 'Found a bug',
        body: "I'm having a problem with this."
      })
    end
  end
end
