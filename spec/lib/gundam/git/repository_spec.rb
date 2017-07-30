require 'spec_helper'

describe Gundam::Git::Repository do
  describe '#current_branch' do
    it 'returns the current branch' do
      change_to_git_repo_with_topic_branch do |repo_dir|
        repository = described_class.new(repo_dir)
        expect(repository.current_branch).to eq('1-topic-branch')
      end
    end
  end

  describe '#exists_remote_branch?' do
    it 'returns true if there is a remote branch' do
      change_to_git_repo_with_topic_branch do |repo_dir|
        repository = described_class.new(repo_dir)

        allow(repository).to receive(:`)
          .with('git config --get remote.origin.url').and_call_original

        allow(repository).to receive(:`)
          .with('git rev-parse --abbrev-ref HEAD').and_call_original

        expect(repository).to receive(:`)
          .with('git ls-remote --exit-code --heads git@github.com:github/octocat.git 1-topic-branch')

        allow($CHILD_STATUS).to receive(:exitstatus).and_return(0)

        expect(repository.exist_remote_branch?).to eq(true)
      end
    end
  end

  describe '#push_set_upstream' do
    it 'pushes and set upstream on the current local branch' do
      change_to_git_repo_with_topic_branch do |repo_dir|
        repository = described_class.new(repo_dir)

        allow(repository).to receive(:`)
          .with('git rev-parse --abbrev-ref HEAD').and_call_original

        expect(repository).to receive(:`)
          .with('git push --set-upstream origin 1-topic-branch')

        repository.push_set_upstream
      end
    end
  end
end
