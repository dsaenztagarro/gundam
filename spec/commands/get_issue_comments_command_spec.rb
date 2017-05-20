require 'spec_helper'

describe GetIssueCommentsCommand do
  describe '#run' do
    it 'returns the comments of the issue' do
      connection = double('Octokit::Client')

      response = github_api_v3_resource :get_issue_comments

      allow(connection).to \
        receive(:issue_comments).with('github/octocat', 1).and_return(response)

      allow(Platforms::Github::ConnectionFactory).to \
        receive(:new_connection).and_return(connection)

      change_to_git_repo_with_topic_branch do |repo_dir|
        command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

        expected_output = "> [octocat] (2011-04-14T16:00:49Z)\n" \
                          "  Me too\n\n"

        expect { command.run }.to output(expected_output).to_stdout
      end
    end
  end
end
