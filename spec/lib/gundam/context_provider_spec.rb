require 'spec_helper'

describe Gundam::ContextProvider do
  describe '#load_context' do
    context 'when base dir is a git repo' do
      it 'returns context for that repo' do
        change_to_git_repo_with_topic_branch do |repo_dir|
          context = subject.load_context(base_dir: repo_dir)

          expect(context).to be_a(Gundam::CommandContext)
          expect(context.repository).to eq('github/octocat')
        end
      end
    end

    context 'when base dir is not a repo' do
      it 'raises an exception' do
        Dir.mktmpdir do |dir|
          expect { subject.load_context(base_dir: dir) }.to raise_error(Gundam::LocalRepoNotFound)
        end
      end
    end
  end
end
