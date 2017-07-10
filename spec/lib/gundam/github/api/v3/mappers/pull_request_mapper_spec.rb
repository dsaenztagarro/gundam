require 'spec_helper'

describe Gundam::Github::API::V3::PullRequestMapper do
  let(:resource) { github_api_v3_response :create_pull_request }

  describe '.load' do
    it 'returns the expected instance' do
      object = described_class.load(resource)

      expect(object.body).to eq('Please pull these awesome changes')
      expect(object.created_at).to eq('2011-01-26T19:01:12Z')
      expect(object.created_by).to eq('octocat')
      expect(object.head_repo_full_name).to eq('octocat/Hello-World')
      expect(object.head_sha).to eq('6dcb09b5b57875f334f61aebed695e2e4193db5e')
      expect(object.html_url).to eq('https://github.com/octocat/Hello-World/pull/1347')
      expect(object.number).to eq(1347)
      expect(object.source_branch).to eq('new-topic')
      expect(object.target_branch).to eq('master')
      expect(object.title).to eq('new-feature')
      expect(object.updated_at).to eq('2011-01-26T19:01:12Z')
    end
  end
end
