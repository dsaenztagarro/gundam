require 'spec_helper'

describe Platforms::Github::API::V3::Gateways::PullRequestGateway do
  let(:resource) { github_api_v3_response :create_pull_request }
  let(:subject)  { described_class.new(resource) }

  describe '#to_h' do
    it 'returns true' do
      expect(subject.to_h).to eq({
        body: 'Please pull these awesome changes',
        created_at: '2011-01-26T19:01:12Z',
        created_by: 'octocat',
        head_repo_full_name: 'octocat/Hello-World',
        head_sha: '6dcb09b5b57875f334f61aebed695e2e4193db5e',
        html_url: 'https://github.com/octocat/Hello-World/pull/1347',
        number: 1347,
        source_branch: 'new-topic',
        target_branch: 'master',
        title: 'new-feature',
        updated_at: '2011-01-26T19:01:12Z',
      })
    end
  end
end
