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
end
