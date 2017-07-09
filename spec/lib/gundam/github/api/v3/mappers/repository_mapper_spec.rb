require 'spec_helper'

describe Gundam::Github::API::V3::RemoteRepositoryMapper do
  let(:resource) { github_api_v3_response :get_repository }

  describe '.load' do
    it 'returns the expected instance' do
      object = described_class.load(resource)

      expect(object).to be_a(Gundam::RemoteRepository)
      expect(object.default_branch).to eq('master')
      expect(object.name).to eq('Hello-World')
      expect(object.full_name).to eq('octocat/Hello-World')
    end
  end
end
