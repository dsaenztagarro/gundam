require 'spec_helper'

describe GetPullRequestCommand do
  let(:client) { double('Octokit::Client') }

  describe '#run' do
    it 'returns the issue' do
      response = github_api_v3_response :get_pull_requests

      allow(client).to \
        receive(:pull_requests).
        with('github/octocat', status: 'open', head: 'github:1-topic-branch').
        and_return(response)

      allow(Platforms::Github::API::V3::Connector).to \
        receive(:new_client).and_return(client)

      change_to_git_repo_with_topic_branch do |repo_dir|
        command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

        expected_output = <<~END
          \e[35mnew-feature #1347\e[0m
          Please pull these awesome changes
        END

        expect { command.run }.to output(expected_output).to_stdout
      end
    end
  end
end
