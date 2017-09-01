require 'spec_helper'

describe Gundam::Context::WithRepository do
  let(:base_dir) { '/base/dir' }
  let(:cli_options) { {} }
  let(:context_class) do
    Class.new do
      include Gundam::Context::WithRepository
      attr_reader :base_dir, :cli_options

      def initialize(base_dir, cli_options = {})
        @base_dir = base_dir
        @cli_options = cli_options
      end
    end
  end

  let(:cli_options_with_local_repo) { {} }

  let(:cli_options_without_local_repo) do
    { platform_constant_name: 'Github',
      repository: 'octocat/Hello-World' }
  end

  let(:subject) { context_class.new(base_dir, cli_options) }

  describe '#local_repo?' do
    context 'with repository cli option' do
      let(:cli_options) do
        { repository: 'octocat/Hello-World' }
      end

      it 'returns false' do
        expect(subject.local_repo?).to eq(false)
      end
    end

    context 'without repository cli option' do
      it 'returns true' do
        expect(subject.local_repo?).to eq(true)
      end
    end
  end

  describe '#repository' do
    context 'with repository option' do
      let(:cli_options) do
        { repository: 'octocat/Hello-World' }
      end

      it 'returns the option value' do
        expect(subject.repository).to eq('octocat/Hello-World')
      end
    end

    context 'without repository option' do
      context 'and local repo present in base dir' do
        before do
          local_repository = double(full_name: 'octocat/Hello-World')

          allow(Gundam::LocalRepository).to receive(:at).with(base_dir)
            .and_return(local_repository)
        end

        it 'returns the local repo full name' do
          expect(subject.repository).to eq('octocat/Hello-World')
        end
      end

      context 'and local repo is not present in base dir' do
        before do
          allow(Gundam::LocalRepository).to receive(:at).with(base_dir)
        end

        it 'raises an error' do
          expect { subject.repository }.to raise_error do |error|
            expect(error).to be_a(Gundam::LocalRepoNotFound)
            expect(error.user_message).to eq('Not found local repo at /base/dir')
          end
        end
      end
    end
  end

  describe '#repo_service' do
    context 'without local repo' do
      let(:cli_options) { cli_options_without_local_repo }

      it 'returns the service' do
        service = double('Gundam::Github::Gateway')
        factory = double('Gundam::RepoServiceFactory')

        allow(Gundam::RepoServiceFactory).to receive(:with_platform)
          .with('Github').and_return(factory)
        allow(factory).to receive(:build).and_return(service)

        expect(subject.repo_service).to eq(service)
      end
    end
  end
end
