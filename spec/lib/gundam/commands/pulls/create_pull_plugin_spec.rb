# frozen_string_literal: true

require 'spec_helper'

describe Gundam::CreatePullPlugin do
  let(:repo_service) { double('Gundam::Github::API::V3::Gateway') }
  let(:local_repo) do
    double('Git::Repository', current_branch: '1-new-feature',
                              full_name: 'octocat/Hello-World')
  end
  let(:context) do
    double('Gundam::Context', local_repo: local_repo,
                              repo_service: repo_service)
  end

  let(:plugin) { double('Gundam::Plugin') }
  let(:decorator) { double('Gundam::PullRequestDecorator') }

  let(:subject) { described_class.new(context) }

  let(:issue) { create_issue }

  let(:remote_repository) do
    Gundam::RemoteRepository.new(
      name: 'Hello-World',
      owner: 'octocat',
      default_branch: 'stable',
      full_name: 'octocat/Hello-World'
    )
  end

  describe '#pull_request_options' do
    before do
      allow(repo_service).to receive(:repository).with('octocat/Hello-World')
                                                 .and_return(remote_repository)

      allow(repo_service).to receive(:issue).with('octocat', 'Hello-World', 1)
                                            .and_return(issue)
    end

    it 'returns the expected options' do
      expect(subject.pull_request_options).to eq(
        base: 'stable',
        body: 'This PR implements #1',
        head: '1-new-feature',
        repo: 'octocat/Hello-World',
        title: 'Found a bug'
      )
    end
  end
end
