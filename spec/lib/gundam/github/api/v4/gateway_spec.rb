require 'spec_helper'

describe Gundam::Github::API::V4::Gateway do
  before { WebMock.disable_net_connect! }

  describe "#issue" do
    context 'when status of response 200' do
      before { stub_github_api_v4_request(:issue) }

      it 'returns the issue' do
        stub_github_api_v4_request(:issue)

        issue = subject.issue('octocat/Hello-World', 1347)
        expect(issue).to be_a(Gundam::Issue)
        expect(issue.body).to eq("I'm having a problem with this.")
        expect(issue.repository).to eq('octocat/Hello-World')
        expect(issue.title).to eq('Found a bug')
      end

      it 'caches response on first call' do
        subject.issue('octocat/Hello-World', 1347)
        subject.issue('octocat/Hello-World', 1347)
        expect(a_request(:post, 'https://api.github.com/graphql')).to have_been_made.times(1)
      end
    end

    context 'when status of response 401' do
      before do
        stub_github_api_v4_request(:issue, {
          status: 401,
          response: "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        })
      end

      it 'raises an error' do
        expect do
          subject.issue('octocat/Hello-World', 1347)
        end.to raise_error(Gundam::Unauthorized)
      end
    end
  end

  describe "#issue_comments" do
    it 'returns the issue comments' do
      stub_github_api_v4_request(:issue)

      comments = subject.issue_comments('octocat/Hello-World', 1347)

      expect(comments).to be_a(Array)
      expect(comments.size).to eq(2)

      comment1 = comments.first
      expect(comment1).to be_a(Gundam::IssueComment)
      expect(comment1.id).to eq(318212279)
      expect(comment1.author).to eq('octocat')
      expect(comment1.updated_at).to eq('2011-04-14T16:00:49Z')
      expect(comment1.body).to eq('Hello world')
    end
  end
end
