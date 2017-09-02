# frozen_string_literal: true

require 'spec_helper'

describe Gundam::PullFinder do
  let(:pull) { double('Gundam::PullRequest') }

  let(:subject) { described_class.new(context) }

  describe '#find' do
    context 'with local repo' do
      let(:local_repo) { double('Gundam::LocalRepository') }

      let(:context) do
        double(
          local_repo?: true,
          local_repo: local_repo
        )
      end

      it 'returns the pull' do
        allow(local_repo).to receive(:current_pull).and_return(pull)
        expect(subject.find).to eq(pull)
      end
    end

    context 'without local repo' do
      let(:repo_service) { double('RepoService') }

      let(:context) do
        double(
          cli_options: { number: 1347 },
          local_repo?: false,
          repository: 'octocat/Hello-World',
          number: 1347,
          repo_service: repo_service
        )
      end

      it 'returns the pull' do
        allow(repo_service).to receive(:pull_request)
          .with('octocat/Hello-World', 1347).and_return(pull)

        expect(subject.find).to eq(pull)
      end
    end
  end
end
