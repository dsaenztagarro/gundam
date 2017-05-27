require 'spec_helper'

describe GetIssueCommentsCommand, type: :github do
  describe '#run' do
    context 'GraphQL API V4' do
      it 'returns the comments of the issue' do
        WebMock.disable_net_connect!
        stub_github_api_v4_request(:issue_comments)

        change_to_git_repo_with_topic_branch do |repo_dir|
          command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

          expected_output = <<~END
          \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m
          Hello world
          \e[36mtron\e[0m \e[34m2017-05-26T21:57:31Z\e[0m
          Good bye
          END
          expect { command.run }.to output(expected_output).to_stdout
        end
      end
    end
  end
end
