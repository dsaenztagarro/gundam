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

  describe '#update_comment' do
    it 'returns the comment created' do
      allow(client).to \
        receive(:update_comment)
        .with('octocat/Hello-World', 1, 'Me too')
        .and_return(github_api_v3_response(:create_issue_comment))

      response = subject.update_comment('octocat/Hello-World', 1, 'Me too')

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
        .with('octocat/Hello-World', 1347)
        .and_return(github_api_v3_response(:get_issue))

      response = subject.issue('octocat/Hello-World', 1347)

      expect(response).to be_a(Gundam::Issue)
      expect(response.body).to eq("I'm having a problem with this.")
      expect(response.number).to eq(1347)
      expect(response.title).to eq('Found a bug')
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

  describe '#issue_comment' do
    it 'returns the comment' do
      allow(client).to \
        receive(:issue_comment)
        .with('octocat/Hello-World', 1_296_269)
        .and_return(github_api_v3_response(:get_issue_comment))

      response = subject.issue_comment('octocat/Hello-World', 1_296_269)

      expect(response).to be_a(Gundam::IssueComment)
      expect(response.body).to eq('Me too')
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

    it 'raises an error with invalid credentials' do
      allow(client).to receive(:repository).with('octocat/Hello-World')
        .and_raise(Octokit::Unauthorized)

      expect do
        subject.repository('octocat/Hello-World')
      end.to raise_error(Gundam::Unauthorized)
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
      allow(client).to receive(:create_pull_request)
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

    context 'when there is client error' do
      before do
        allow(client).to receive(:create_pull_request).with(any_args).and_raise(Octokit::Error)
      end

      it 'raises an exception' do
        expect do
          subject.create_pull_request(
            repo: 'octocat/Hello-World',
            base: 'master',
            head: 'new-topic',
            title: 'new-feature',
            body: 'Please pull these awesome changes')
        end.to raise_error(Gundam::CreatePullRequestError)
      end
    end
  end

  describe '#update_pull_request' do
    it 'creates a pull request' do
      allow(client).to receive(:update_pull_request)
        .with('octocat/Hello-World', 2, body: 'Please pull these awesome changes')
        .and_return(github_api_v3_response(:update_pull_request))

      response = subject.update_pull_request(
        'octocat/Hello-World', 2, 'Please pull these awesome changes')

      expect(response).to be_a Gundam::PullRequest
      expect(response.body).to eq('Please pull these awesome changes')
      expect(response.head_repo_full_name).to eq('octocat/Hello-World')
      expect(response.head_sha).to eq('6dcb09b5b57875f334f61aebed695e2e4193db5e')
      expect(response.html_url).to eq('https://github.com/octocat/Hello-World/pull/1347')
      expect(response.source_branch).to eq('new-topic')
      expect(response.target_branch).to eq('master')
    end
  end

  describe '#org_teams' do
    it 'returns the teams of an organization' do
      allow(client).to receive(:org_teams).with('myorg')
        .and_return(github_api_v3_response(:get_teams))

      result = subject.org_teams('myorg')

			expected_teams = [{id: 1, name: 'Justice League'}, {id: 2, name: 'ATeam'}]

      expect(result).to be_a(Array)

			result.zip(expected_teams).each do |team, expected_team|
				expect(team).to be_a(Gundam::Team)
				expect(team.id).to eq(expected_team[:id])
				expect(team.name).to eq(expected_team[:name])
			end
    end
  end

  describe '#team_members' do
    it 'returns the members of the team' do
      allow(client).to receive(:teams)
        .and_return(github_api_v3_response(:get_teams))

      allow(client).to receive(:team_members).with(2)
        .and_return(github_api_v3_response(:get_team_members))

      result = subject.team_members(2)

			expected_team_members = [{id: 1, login: 'octocat'}, {id: 2, login: 'zuma'}]

      expect(result).to be_a(Array)

			result.zip(expected_team_members).each do |member, expected_member|
				expect(member).to be_a(Gundam::TeamMember)
				expect(member.id).to eq(expected_member[:id])
				expect(member.login).to eq(expected_member[:login])
			end
    end
  end
end
