require 'spec_helper'

describe CreatePullRequestCommand do
  describe '#run' do
    it 'returns the created pull request' do
      connection = double('Octokit::Client')

      allow(connection).to receive(:repository).
        with('github/octocat').
        and_return(github_api_v3_resource :get_repository)

      allow(connection).to receive(:issue).
        with('octocat/Hello-World', 1).
        and_return(github_api_v3_resource :get_issue)

      allow(connection).to receive(:create_pull_request).
        with('octocat/Hello-World',
             'master',
             '1-topic-branch',
             'Found a bug',
             'This PR implements #1').
        and_return(github_api_v3_resource :create_pull_request)

      allow(Platforms::Github::ConnectionFactory).to \
        receive(:new_connection).and_return(connection)

      change_to_git_repo_with_topic_branch do |repo_dir|
        command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

        expected_output = "\n https://github.com/octocat/Hello-World/pull/1347\n"

        expect { command.run }.to output(expected_output).to_stdout
      end
    end
  end
end
