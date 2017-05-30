require 'spec_helper'

describe Platforms::Github::Service do
  let(:connector) { double('Platforms::Github::API::V3::Connector') }
  let(:subject)   { described_class.new(connector) }

  describe '#issue' do
    it 'returns the Issue' do
      response = { title: 'Found a bug', body: 'The body of the issue' }

      allow(connector).to receive(:issue).with('octocat/Hello-World', 1296269).
                          and_return(response)

      result = subject.issue('octocat/Hello-World', 1296269)

      expect(result).to be_a Issue
      expect(result.title).to eq('Found a bug')
    end
  end

  describe '#issue_comments' do
    it 'returns a list of IssueComment' do
      response = [{
        body: 'Me too',
        user_login: 'octocat',
        created_at: '2011-04-14T16:00:49Z',
        updated_at: '2011-04-14T16:00:49Z'
      }]

      allow(connector).to \
        receive(:issue_comments).with('octocat/Hello-World', 1296269).
        and_return(response)

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
      response = { name: 'octocat/Hello-World', default_branch: 'master' }

      allow(connector).to receive(:repository).with('octocat/Hello-World').
                          and_return(response)

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
    let(:html_url) { 'https://github.com/github/octocat/pull/27' }

    it 'returns the created PullRequest' do
      response = {
        title: title,
        number: 1347,
        created_by: 'octocat',
        created_at: '2011-01-26T19:01:12Z',
        updated_at: '2011-01-26T19:01:12Z',
        body: body,
        source_branch: head,
        target_branch: base,
        html_url: html_url
      }

      allow(connector).to receive(:create_pull_request)
				.with(repo, base, head, title, body).and_return(response)

      result = subject.create_pull_request(
				repo: repo, base: base, head: head, title: title, body: body)

      expect(result).to be_a PullRequest
      expect(result.title).to eq(title)
      expect(result.body).to eq(body)
      expect(result.source_branch).to eq(head)
      expect(result.target_branch).to eq(base)
      expect(result.html_url).to eq(html_url)
    end
	end
end
