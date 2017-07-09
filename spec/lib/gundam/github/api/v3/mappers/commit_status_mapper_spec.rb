require 'spec_helper'

describe Gundam::Github::API::V3::CommitStatusMapper do
  let(:resource) { github_api_v3_response(:get_commit_statuses).first }

  describe '.load' do
    it 'returns the expected instance' do
      object = described_class.load(resource)

      expect(object).to be_a(Gundam::CommitStatus)
      expect(object.created_at).to eq('2012-07-20T01:19:13Z')
      expect(object.updated_at).to eq('2012-07-20T01:19:13Z')
      expect(object.state).to eq('success')
      expect(object.description).to eq('Build has completed successfully')
      expect(object.target_url).to eq('https://ci.example.com/1000/output')
      expect(object.context).to eq('continuous-integration/jenkins')
    end
  end
end
