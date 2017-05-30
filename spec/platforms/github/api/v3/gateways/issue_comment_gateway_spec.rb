require 'spec_helper'

describe Platforms::Github::API::V3::Gateways::IssueCommentGateway do
  let(:resource) { github_api_v3_response :get_issue_comments }
  let(:subject)  { described_class.new(resource.first) }

  describe '#to_h' do
    it 'returns true' do
      expect(subject.to_h).to eq({
        body: 'Me too',
        created_at: '2011-04-14T16:00:49Z',
        updated_at: '2011-04-14T16:00:49Z',
        user_login: 'octocat'
      })
    end
  end
end
