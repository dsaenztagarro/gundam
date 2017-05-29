require 'spec_helper'

describe GetIssueCommentsCommand, type: :github do
  describe '#run' do
    context 'when GraphQL API V4' do
      before { WebMock.disable_net_connect! }

      context 'and status 200' do
        before do
          stub_github_api_v4_request(:issue_comments)
        end

        it 'returns the comments of the issue' do
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

      context 'and status 401' do
        before do
          stub_github_api_v4_request(:issue_comments, {
            status: 401,
            response: "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
          })
        end

        it 'returns the comments of the issue' do
          change_to_git_repo_with_topic_branch do |repo_dir|
            command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

            expected_output = <<~END
              \e[31m{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}\e[0m
            END
            expect { command.run }.to output(expected_output).to_stdout
          end
        end
      end
    end

    context 'when Rest API V3' do
      let(:client) { double('Octokit::Client') }
      let(:connector) { Platforms::Github::API::V3::Connector.new }

      before do
        allow(Platforms::Github::API::V3::Connector).to \
          receive(:new_client).and_return(client)

        allow(client).to receive(:issue_comments).
          with('github/octocat', 1).
          and_return(github_api_v3_response :get_issue_comments)

        service = Platforms::Github::Service.new(connector)

        allow(PlatformServiceFactory).to receive(:build).and_return(service)
      end

      it 'returns the comments of the issue' do
        change_to_git_repo_with_topic_branch do |repo_dir|
          command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

          expected_output = <<~END
          \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m
          Me too
          END

          expect { command.run }.to output(expected_output).to_stdout
        end
      end
    end
  end
end
