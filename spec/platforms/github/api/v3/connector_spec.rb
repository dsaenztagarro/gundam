require 'spec_helper'

describe Platforms::Github::API::V3::Connector do
  let(:client)  { double('Octokit::Client') }
  let(:subject) { described_class.new(client) }

  before do
    allow(described_class).to receive(:new_client).and_return(client)
  end

  describe '#add_comment' do
    it 'returns the comment created' do
      allow(client).to \
        receive(:add_comment).
        with('github/octocat', 1, 'Me too').
        and_return(github_api_v3_response :create_issue_comment)

      response = subject.add_comment('github/octocat', 1, 'Me too')

      expect(response.class).to eq(IssueComment)
      expect(response.body).to eq('Me too')
      expect(response.created_at).to eq('2011-04-14T16:00:49Z')
      expect(response.html_url).to eq('https://github.com/octocat/Hello-World/issues/1347#issuecomment-1')
      expect(response.id).to eq(1)
      expect(response.updated_at).to eq('2011-04-14T16:00:49Z')
    end
  end
end
