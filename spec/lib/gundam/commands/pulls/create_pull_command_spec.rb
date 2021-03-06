# frozen_string_literal: true

require 'spec_helper'

describe Gundam::CreatePullCommand do
  let(:repo_service) { double('Gundam::Github::Gateway') }
  let(:local_repo) { double('Git::Repository') }
  let(:context) do
    double(local_repo: local_repo, repo_service: repo_service)
  end

  let(:plugin) { double('Gundam::Plugin') }
  let(:pull_options) { double('options') }
  let(:pull) { create_pull }
  let(:pull_decorated) { double(string_on_create: 'PULL') }

  let(:subject) { described_class.new(context) }

  describe '#run' do
    before do
      allow(Gundam::CreatePullPlugin).to receive(:new).with(context)
                                                      .and_return(plugin)
      allow(plugin).to receive(:pull_request_options).and_return(pull_options)

      allow(Gundam::PullDecorator).to receive(:new).with(pull)
                                                   .and_return(pull_decorated)
    end

    context 'when the upstream is present' do
      before do
        allow(local_repo).to receive(:exist_remote_branch?).and_return(true)
      end

      it 'creates the pull request' do
        expect(repo_service).to receive(:create_pull_request).with(pull_options)
                                                             .and_return(pull)

        expect(subject).to receive(:`).with('echo https://github.com/octocat/Hello-World/pull/1347 | pbcopy')

        expect { subject.run }.to output("PULL\n").to_stdout
      end

      context 'and there is an error creating PR' do
        before do
          @error = Gundam::CreatePullRequestError.new
          allow(repo_service).to receive(:create_pull_request).and_raise(@error)
        end

        it 'raises an error' do
          expect { subject.run }.to raise_error(@error)
        end
      end
    end

    context 'when the upstream is present' do
      before do
        allow(local_repo).to receive(:exist_remote_branch?).and_return(false)
      end

      it 'creates the pull request' do
        expect(local_repo).to receive(:push_set_upstream)

        expect(repo_service).to receive(:create_pull_request).with(pull_options)
                                                             .and_return(pull)

        expect(subject).to receive(:`).with('echo https://github.com/octocat/Hello-World/pull/1347 | pbcopy')

        expect { subject.run }.to output("PULL\n").to_stdout
      end
    end
  end
end
