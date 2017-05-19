require 'spec_helper'

describe Platforms::Github::PullRequestGateway do
  let(:resource) { github_api_v3_resource :create_pull_request }
  let(:subject)  { described_class.new(resource) }

  describe '#to_h' do
    it 'returns true' do
      expect(subject.to_h).to eq({
        title: 'new-feature',
        body: 'Please pull these awesome changes',
        source_branch: 'new-topic',
        target_branch: 'master',
        html_url: 'https://github.com/octocat/Hello-World/pull/1347'
      })
    end
  end
end
