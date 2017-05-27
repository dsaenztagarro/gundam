require 'spec_helper'

describe Platforms::Github::API::V3::RepositoryGateway do
  let(:resource) { github_api_v3_response :get_repository }
  let(:subject)  { described_class.new(resource) }

  describe '#to_h' do
    it 'returns true' do
      expect(subject.to_h).to eq({
        default_branch: 'master',
        name: 'octocat/Hello-World',
      })
    end
  end
end
