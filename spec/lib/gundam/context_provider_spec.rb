# frozen_string_literal: true

require 'spec_helper'

describe Gundam::ContextProvider do
  describe '#load_context' do
    context 'when base dir is a Github cloned git repo', speed: 'slow' do
      context 'and target is issue' do
        it 'returns the issue context' do
          change_to_git_repo_with_topic_branch do |repo_dir|
            subject.cli_options = { base_dir: repo_dir }

            context = subject.load_context

            expect(context).to be_a(Gundam::CommandContext)
            expect(context.repository).to eq('github/octocat')
            expect(context.repo_service).to be_a(Gundam::Github::Gateway)
          end
        end

        context 'and target is pull' do
          let(:client) { double('Octokit::Client') }

          before do
            allow(Gundam::Github::Gateway).to receive(:new_client)
              .and_return(client)
          end

          context 'and a pull exists' do
            before do
              allow(client).to receive(:pull_requests)
                .with('github/octocat', status: 'open', head: 'github:1-topic-branch')
                .and_return(github_api_v3_response(:get_pull_requests))
            end

            it 'returns the pull context' do
              change_to_git_repo_with_topic_branch do |repo_dir|
                subject.cli_options = { base_dir: repo_dir }

                context = subject.load_context

                expect(context).to be_a(Gundam::CommandContext)
                expect(context.repository).to eq('github/octocat')
                expect(context.repo_service).to be_a(Gundam::Github::Gateway)
              end
            end
          end
        end
      end
    end

    context "when base dir doesn't exist" do
      it 'raises an exception' do
        expect do
          subject.cli_options = { base_dir: '/invalid/dir' }
          subject.load_context
        end.to raise_error do |error|
          expect(error).to be_a(Gundam::BaseDirNotFound)
          expect(error.user_message).to eq("Doesn't exist base dir /invalid/dir")
        end
      end
    end
  end
end
