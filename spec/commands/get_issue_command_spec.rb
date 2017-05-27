require 'spec_helper'

describe GetIssueCommand do
  let(:client) { double('Octokit::Client') }

  describe '#run' do
    it 'returns the issue' do
      response = github_api_v3_response :get_issue

      allow(client).to \
        receive(:issue).with('github/octocat', 1).and_return(response)

      allow(Platforms::Github::API::V3::Connector).to \
        receive(:new_client).and_return(client)

      change_to_git_repo_with_topic_branch do |repo_dir|
        command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

        expected_output = "\e[31mFound a bug\e[0m\n" \
                          "I'm having a problem with this.\n"

        expect { command.run }.to output(expected_output).to_stdout
      end
    end
  end
end
