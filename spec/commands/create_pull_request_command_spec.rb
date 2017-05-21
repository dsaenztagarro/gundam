require 'spec_helper'

describe CreatePullRequestCommand do
  let(:connection) { double('Octokit::Client') }

  describe '#run' do
    before do
      allow(connection).to receive(:repository).
        with('github/octocat').
        and_return(github_api_v3_resource :get_repository)

      allow(connection).to receive(:issue).
        with('octocat/Hello-World', 1).
        and_return(github_api_v3_resource :get_issue)

      allow(Platforms::Github::ConnectionFactory).to \
        receive(:new_connection).and_return(connection)
    end

    context 'when PR is created' do
      before do
        allow(connection).to receive(:create_pull_request).
          with('octocat/Hello-World',
               'master',
               '1-topic-branch',
               'Found a bug',
               'This PR implements #1').
          and_return(github_api_v3_resource :create_pull_request)
      end

      it 'prints the url of the created PR' do
        change_to_git_repo_with_topic_branch do |repo_dir|
          command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

          expected_output = "https://github.com/octocat/Hello-World/pull/1347\n"

          expect { command.run }.to output(expected_output).to_stdout
        end
      end
    end

    context 'when there is an error creating PR' do
      before do
        allow(connection).to \
          receive(:create_pull_request).and_raise(Octokit::Error)
      end

      it 'prints the error' do
        change_to_git_repo_with_topic_branch do |repo_dir|
          command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

          expect { command.run }.to output("Octokit::Error\n").to_stdout
        end
      end
    end
  end
end
