require 'spec_helper'

describe Gundam::Github::API::V3::Gateway do
  let(:client)  { double('Octokit::Client') }
  let(:subject) { described_class.new(client) }

  before do
    allow(described_class).to receive(:new_client).and_return(client)
  end

  describe '#add_comment' do
    it 'returns the comment created' do
      allow(client).to \
        receive(:add_comment)
        .with('octocat/Hello-World', 1, 'Me too')
        .and_return(github_api_v3_response(:create_issue_comment))

      response = subject.add_comment('octocat/Hello-World', 1, 'Me too')

      expect(response).to be_a(Gundam::IssueComment)
      expect(response.body).to eq('Me too')
      expect(response.created_at).to eq('2011-04-14T16:00:49Z')
      expect(response.html_url).to eq('https://github.com/octocat/Hello-World/issues/1347#issuecomment-1')
      expect(response.id).to eq(1)
      expect(response.updated_at).to eq('2011-04-14T16:00:49Z')
    end
  end

  describe '#issue' do
    it 'returns the Issue' do
      allow(client).to \
        receive(:issue)
        .with('octocat/Hello-World', 1_296_269)
        .and_return(github_api_v3_response(:get_issue))

      response = subject.issue('octocat/Hello-World', 1_296_269)

      expect(response).to be_a(Gundam::Issue)
      expect(response.title).to eq('Found a bug')
      expect(response.body).to eq("I'm having a problem with this.")
    end
  end

  describe '#issue_comments' do
    it 'returns a list of comments' do
      allow(client).to \
        receive(:issue_comments)
        .with('octocat/Hello-World', 1_296_269)
        .and_return(github_api_v3_response(:get_issue_comments))

      response = subject.issue_comments('octocat/Hello-World', 1_296_269)

      expect(response).to be_a(Array)
      expect(response.size).to eq(1)

      comment = response.first
      expect(comment.body).to eq('Me too')
    end
  end

  describe '#pull_request' do
    it 'returns a pull request' do
      allow(client).to receive(:pull_request).with('octocat/Hello-World', 1)
        .and_return(github_api_v3_response(:get_pull_request))

      response = subject.pull_request('octocat/Hello-World', 1)

      expect(response).to be_a(Gundam::PullRequest)
      expect(response.title).to eq('new-feature')
      expect(response.body).to eq('Please pull these awesome changes')
    end

    it 'raises an error when the pull is not found' do
      allow(client).to receive(:pull_request).with('octocat/Hello-World', 1)
        .and_raise(Octokit::NotFound)

      expect do
        subject.pull_request('octocat/Hello-World', 1)
      end.to raise_error(Gundam::PullRequestNotFound)
    end
  end

  describe '#pull_requests' do
    it 'returns the Issue' do
      allow(client).to receive(:pull_requests)
        .with('octocat/Hello-World', anything)
        .and_return(github_api_v3_response(:get_pull_requests))

      response = subject.pull_requests('octocat/Hello-World', anything)

      expect(response).to be_a(Array)
      expect(response.size).to eq(1)

      pull = response.first
      expect(pull).to be_a(Gundam::PullRequest)
      expect(pull.title).to eq('new-feature')
      expect(pull.body).to eq('Please pull these awesome changes')
    end
  end

  describe '#repository' do
    it 'returns a single repository' do
      allow(client).to receive(:repository).with('octocat/Hello-World')
        .and_return(github_api_v3_response(:get_repository))

      response = subject.repository('octocat/Hello-World')

      expect(response).to be_a(Gundam::RemoteRepository)
      expect(response.owner).to eq('octocat')
      expect(response.name).to eq('Hello-World')
      expect(response.full_name).to eq('octocat/Hello-World')
      expect(response.default_branch).to eq('master')
    end
  end

  describe '#statuses' do
    it 'returns the last' do
      head_sha = '6dcb09b5b57875f334f61aebed695e2e4193db5e'

      allow(client).to receive(:statuses)
        .with('octocat/Hello-World', head_sha)
        .and_return(github_api_v3_response(:get_commit_statuses))

      response = subject.statuses('octocat/Hello-World', head_sha)

      expect(response).to be_a(Array)
      obj = response.first
      expect(obj).to be_a(Gundam::CommitStatus)
      expect(obj.state).to eq('success')
    end
  end

  describe '#create_pull_request' do
    it 'creates a pull request' do
      allow(client).to \
        receive(:create_pull_request)
        .with('octocat/Hello-World', 'master', 'new-topic', 'new-feature', 'Please pull these awesome changes')
        .and_return(github_api_v3_response(:create_pull_request))

      response = subject.create_pull_request(
        repo: 'octocat/Hello-World',
        base: 'master',
        head: 'new-topic',
        title: 'new-feature',
        body: 'Please pull these awesome changes')

      expect(response).to be_a Gundam::PullRequest
      expect(response.body).to eq('Please pull these awesome changes')
      expect(response.head_repo_full_name).to eq('octocat/Hello-World')
      expect(response.head_sha).to eq('6dcb09b5b57875f334f61aebed695e2e4193db5e')
      expect(response.html_url).to eq('https://github.com/octocat/Hello-World/pull/1347')
      expect(response.source_branch).to eq('new-topic')
      expect(response.target_branch).to eq('master')
    end
  end
end
