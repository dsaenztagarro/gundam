require 'spec_helper'

describe Platforms::Github::API::V3::Gateways::CommitStatusGateway do
  let(:resource) { github_api_v3_response(:get_commit_statuses).first }
  let(:subject)  { described_class.new(resource) }

  describe '#to_h' do
    it 'returns true' do
      expect(subject.to_h).to eq({
        created_at: '2012-07-20T01:19:13Z',
        updated_at: '2012-07-20T01:19:13Z',
        state: 'success',
        description: 'Build has completed successfully',
        target_url: 'https://ci.example.com/1000/output',
        context: 'continuous-integration/jenkins'
      })
    end
  end
end
