require 'spec_helper'

describe GetIssueCommand do
  describe '#run' do
    context 'when GraphQL API V4' do
      let(:connector) { Platforms::Github::API::V4::Connector.new }

      before do
        WebMock.disable_net_connect!

        connector = Platforms::Github::API::V4::Connector.new
        service   = Platforms::Github::Service.new(connector)
        allow(PlatformServiceFactory).to receive(:build).and_return(service)
      end

      context 'and status 200' do
        before do
          stub_github_api_v4_request(:issue)
        end

        context 'with comments' do
          let(:options) do
            { with_comments: true }
          end

          it 'returns the comments of the issue' do
            change_to_git_repo_with_topic_branch do |repo_dir|
              command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

              expected_output = <<~END
                \e[31mFound a bug\e[0m
                I'm having a problem with this.
                \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m
                Hello world
                \e[36mtron\e[0m \e[34m2017-05-26T21:57:31Z\e[0m
                Good bye
              END

              expect { command.run(options) }.to output(expected_output).to_stdout
            end
          end
        end
      end

      context 'and status 401' do
        before do
          stub_github_api_v4_request(:issue, {
            status: 401,
            response: "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
          })
        end

        it 'returns a bad credentials error message' do
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
        allow(client).to \
          receive(:issue).
          with('github/octocat', 1).
          and_return(github_api_v3_response :get_issue)

        allow(Platforms::Github::API::V3::Connector).to \
          receive(:new_client).and_return(client)
      end

      it 'returns the issue' do
        change_to_git_repo_with_topic_branch do |repo_dir|
          command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

          expected_output = <<~END
            \e[31mFound a bug\e[0m
            I'm having a problem with this.
          END

          expect { command.run }.to output(expected_output).to_stdout
        end
      end

      context 'with number' do
        let(:options) do
          { number: 1 }
        end

        context 'and the number of issue exists' do
          it 'returns the issue' do
            change_to_git_repo do |repo_dir|
              command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

              expected_output = <<~END
                \e[31mFound a bug\e[0m
                I'm having a problem with this.
              END

              expect { command.run(options) }.to output(expected_output).to_stdout
            end
          end
        end

        context 'and the number of issue does not exist' do
          it 'returns an error message' do

          end
        end
      end

      context 'with comments' do
        let(:options) do
          { with_comments: true }
        end

        before do
          allow(client).to receive(:issue_comments).
            with('github/octocat', 1).
            and_return(github_api_v3_response :get_issue_comments)
        end

        it 'returns the issue with comments' do
          change_to_git_repo_with_topic_branch do |repo_dir|
            command = described_class.new(base_dir: repo_dir, spinner: SpinnerWrapperDummy.new)

            expected_output = <<~END
            \e[31mFound a bug\e[0m
            I'm having a problem with this.
            \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m
            Me too
            END

            expect { command.run(options) }.to output(expected_output).to_stdout
          end
        end
      end
    end
  end
end
