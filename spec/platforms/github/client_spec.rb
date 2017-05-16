require 'spec_helper'

describe Platforms::Github::Client do
  include GithubHelper

  let(:connection) { double('Platforms::Github::Connection') }
  let(:subject)    { described_class.new(connection) }

  describe '#issue' do
    it 'returns the Issue' do
      api_response = github_api_v3_resource :get_issue
      allow(connection).to receive(:issue).with('octocat/Hello-World', 1296269).and_return(api_response)

      result = subject.issue('octocat/Hello-World', 1296269)

      expect(result).to be_a Issue
      expect(result.title).to eq('Found a bug')
    end
  end

  describe '#issue_comments' do
    it 'returns a list of IssueComment' do
      api_response = github_api_v3_resource :get_issue_comments
      allow(connection).to receive(:issue_comments).with('octocat/Hello-World', 1296269).and_return(api_response)

      result = subject.issue_comments('octocat/Hello-World', 1296269)

      expect(result).to be_a Array
      expect(result.size).to eq(1)

      comment = result.first

      expect(comment).to be_a IssueComment
      expect(comment.body).to eq('Me too')
      expect(comment.user_login).to eq('octocat')
      expect(comment.created_at).to eq('2011-04-14T16:00:49Z')
      expect(comment.updated_at).to eq('2011-04-14T16:00:49Z')
    end
  end

  describe '#repository' do
    it 'returns the Repository' do
      api_response = github_api_v3_resource :get_repository
      allow(connection).to receive(:repository)
				.with('octocat/Hello-World').and_return(api_response)

      result = subject.repository('octocat/Hello-World')

      expect(result).to be_a PlatformRepository
      expect(result.name).to eq('octocat/Hello-World')
      expect(result.default_branch).to eq('master')
    end
  end

  describe '#create_pull_request' do
		let(:repo)  { 'octocat/Hello-World' }
		let(:base)  { 'master' }
		let(:head)  { 'new-topic' }
		let(:title) { 'new-feature' }
		let(:body)  { 'Please pull these awesome changes' }

    it 'returns the created PullRequest' do
      api_response = github_api_v3_resource :create_pull_request
      allow(connection).to receive(:create_pull_request)
				.with(repo, base, head, title, body).and_return(api_response)

      result = subject.create_pull_request(
				repo: repo, base: base, head: head, title: title, body: body)

      expect(result).to be_a PullRequest
      expect(result.title).to eq(title)
      expect(result.body).to eq(body)
      expect(result.source_branch).to eq(head)
      expect(result.target_branch).to eq(base)
    end
	end
end
