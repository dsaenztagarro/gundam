require 'spec_helper'

describe Gundam::Github::API::V3::CombinedStatusRefMapper do
  let(:resource) { github_api_v3_response(:get_combined_status) }

  describe '.load' do
    it 'returns the expected instance' do
      object = described_class.load(resource)

      expect(object).to be_a(Gundam::CombinedStatusRef)
      expect(object.state).to eq('success')
      expect(object.statuses).to be_a(Array)
      expect(object.statuses.size).to eq(2)
    end
  end
end
