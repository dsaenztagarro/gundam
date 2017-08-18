require 'spec_helper'

describe Gundam::IssueFinder do
  let(:issue) { double('Gundam::Issue') }

  let(:subject) { described_class.new(context) }

  describe '#find' do
    context 'with local repo' do
      let(:local_repo) { double('Gundam::LocalRepository') }

      let(:context) do
        double('Context', local_repo?: true, local_repo: local_repo, cli_options: {})
      end

      it 'returns the issue from current branch' do
        allow(local_repo).to receive(:current_issue).and_return(issue)
        expect(subject.find).to eq(issue)
      end

      context 'and option number' do
        before do
          allow(context).to receive(:cli_options).and_return(number: 1347)
        end

        it 'returns the issue with number provided' do
          allow(local_repo).to receive(:issue).with(1347).and_return(issue)
          expect(subject.find).to eq(issue)
        end
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
          repo_service: repo_service)
      end

      it 'returns the issue' do
        allow(repo_service).to receive(:issue).with('octocat/Hello-World', 1347)
          .and_return(issue)

        expect(subject.find).to eq(issue)
      end
    end
  end
end
