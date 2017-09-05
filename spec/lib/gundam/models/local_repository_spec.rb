# frozen_string_literal: true

require 'spec_helper'

describe Gundam::LocalRepository do
  let(:repository) do
    double('Git::Repository', owner: 'octocat',
                              name: 'Hello-World',
                              full_name: 'octocat/Hello-World',
                              current_branch: '1347-new-feature',
                              platform_constant_name: 'Github')
  end
  let(:service) { double }
  let(:factory) { double }
  let(:subject) { described_class.new(repository) }

  describe '#current_pull' do
    before do
      allow(Gundam::RepoServiceFactory).to receive(:with_platform).with('Github')
                                                                  .and_return(factory)
      allow(factory).to receive(:build).and_return(service)
    end

    context 'when exists a pull for the current branch' do
      let(:pull) { double('Pull') }

      before do
        expect(service).to receive(:pulls)
          .with('octocat', 'Hello-World', '1347-new-feature', {})
          .and_return([pull])
      end

      it 'returns the pull' do
        expect(subject.current_pull).to eq(pull)
      end
    end

    context 'when does not exist a pull for the current branch' do
      before do
        expect(service).to receive(:pulls)
          .with('octocat', 'Hello-World', '1347-new-feature', {}).and_return([])
      end

      it 'raises an error' do
        expect { subject.current_pull }.to raise_error do |error|
          expect(error).to be_a(Gundam::PullRequestForBranchNotFound)
          expect(error.user_message).to eq('Not found PR for branch 1347-new-feature')
        end
      end
    end
  end

  describe '#current_issue' do
    let(:issue) { double }

    context 'when Github remote repository' do
      let(:service) { Gundam::Github::Gateway.new }

      before do
        allow(Gundam::RepoServiceFactory).to receive(:with_platform)
          .with('Github').and_return(factory)
        allow(factory).to receive(:build).and_return(service)

        allow(service).to receive(:issue)
          .with('octocat', 'Hello-World', 1347, {}).and_return(issue)
      end

      it 'returns the issue' do
        expect(subject.current_issue).to eq(issue)
      end

      context 'and the topic branch is not issue related' do
        let(:repository) do
          double('Git::Repository', current_branch: 'master',
                                    platform_constant_name: 'Github')
        end

        it 'raises an error' do
          expect { subject.current_issue }.to raise_error do |error|
            expect(error).to be_a(Gundam::IssueNotFound)
            expect(error.message).to eq('Not found issue for branch master')
          end
        end
      end
    end
  end
end
