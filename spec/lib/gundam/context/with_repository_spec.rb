require 'spec_helper'

describe Gundam::Context::WithRepository do
  let(:context_class) do
    Class.new do
      include Gundam::Context::WithRepository
      attr_reader :cli_options

      def initialize(cli_options = {})
        @cli_options = cli_options
      end
    end
  end

  let(:cli_options_with_local_repo) { {} }

  let(:cli_options_without_local_repo) do
    { without_local_repo: true,
      platform_constant_name: 'Github',
      repository: 'octocat/Hello-World' }
  end

  let(:subject) { context_class.new(cli_options) }

  describe '#local_repo?' do
    context 'with local repo' do
      let(:cli_options) { cli_options_with_local_repo }

      it 'returns true' do
        expect(subject.local_repo?).to eq(true)
      end
    end

    context 'without local repo' do
      let(:cli_options) { cli_options_without_local_repo }

      it 'returns false' do
        expect(subject.local_repo?).to eq(false)
      end
    end
  end

  describe '#repository' do
    context 'without local repo' do
      let(:cli_options) { cli_options_without_local_repo }

      it 'returns the :repository cli option' do
        expect(subject.repository).to eq('octocat/Hello-World')
      end

      context 'and :repository cli option is not present' do
        let(:cli_options) do
          cli_options_without_local_repo.tap do |options|
            options.delete(:repository)
          end
        end

        it 'raises an error' do
          expect { subject.repository }.to raise_error do |error|
            expect(error).to be_a(Gundam::CliOptionError)
            expect(error.user_message).to eq('Missing cli option repository')
          end
        end
      end
    end
  end

  describe '#repo_service' do
    context 'without local repo' do
      let(:cli_options) { cli_options_without_local_repo }

      it 'returns the service' do
        service = double('Gundam::Github::API::V3::Gateway')
        factory = double('Gundam::RepoServiceFactory')

        allow(Gundam::RepoServiceFactory).to receive(:with_platform).with('Github')
          .and_return(factory)
        allow(factory).to receive(:build).and_return(service)

        expect(subject.repo_service).to eq(service)
      end
    end
  end
end
