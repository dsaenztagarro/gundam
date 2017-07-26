require 'spec_helper'

describe Gundam::GetIssueCommand do
  describe '#run' do
    let(:repo_options) do
      { without_local_repo: true, number: 1347 }
    end
    let(:other_options) { {} }
    let(:cli_options) { repo_options.merge(other_options) }

    let(:context) do
      double(cli_options: cli_options,
             local_repo?: false,
             repository: 'octocat/Hello-World',
             number: 1347,
             repo_service: repo_service)
    end
    let(:subject) { described_class.new(context) }

    context 'when GraphQL API V4' do
      let(:repo_service) { Gundam::Github::API::V4::Gateway.new }

      before { WebMock.disable_net_connect! }

      context 'and status 200' do
        before { stub_github_api_v4_request(:issue) }

        context 'with description and comments' do
          let(:other_options) do
            { with_description: true, with_comments: true }
          end

          it 'returns the comments of the issue' do
            expected_output = <<~END
              \e[31mFound a bug\e[0m
              I'm having a problem with this.
              \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m
              Hello world
              \e[36mtron\e[0m \e[34m2017-05-26T21:57:31Z\e[0m
              Good bye
            END

            expect { subject.run }.to output(expected_output).to_stdout
          end
        end
      end

      it 'returns a bad credentials error message with status 401' do
        stub_github_api_v4_request(:issue, {
          status: 401,
          response: "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        })

        expected_output = <<~END
          \e[31m{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}\e[0m
        END

        expect { subject.run }.to output(expected_output).to_stdout
      end
    end

    context 'when Rest API V3' do
      let(:client) { double('Octokit::Client') }
      let(:repo_service) { Gundam::Github::API::V3::Gateway.new }

      before do
        allow(client).to receive(:issue).with('octocat/Hello-World', 1347).
          and_return(github_api_v3_response :get_issue)

        allow(Gundam::Github::API::V3::Gateway).to receive(:new_client).
          and_return(client)
      end

      context 'with description' do
        let(:other_options) do
          { with_description: true }
        end

        it 'returns the issue' do
          expected_output = <<~END
            \e[31mFound a bug\e[0m
            I'm having a problem with this.
          END

          expect { subject.run }.to output(expected_output).to_stdout
        end
      end

      context 'with number and description' do
        let(:other_options) do
          { number: 1347, with_description: true }
        end

        context 'and the number of issue exists' do
          it 'returns the issue' do
            expected_output = <<~END
              \e[31mFound a bug\e[0m
              I'm having a problem with this.
            END

            expect { subject.run }.to output(expected_output).to_stdout
          end
        end

        context 'and the number of issue does not exist' do
          before do
            allow(client).to receive(:issue).and_raise(Octokit::NotFound)
          end

          it 'returns an error message to the user' do
            expected_output = <<~END
              \e[31mNot found issue #1347 on octocat/Hello-World\e[0m
            END

            expect { subject.run }.to output(expected_output).to_stdout
          end
        end
      end

      context 'with description and comments' do
        let(:other_options) do
          { with_description: true, with_comments: true }
        end

        before do
          allow(client).to receive(:issue_comments).
            with('octocat/Hello-World', 1347).
            and_return(github_api_v3_response :get_issue_comments)
        end

        it 'returns the issue with comments' do
          expected_output = <<~END
            \e[31mFound a bug\e[0m
            I'm having a problem with this.
            \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m
            Me too
          END

          expect { subject.run }.to output(expected_output).to_stdout
        end
      end

      context 'when local repo' do
        let(:issue) do
          Gundam::Issue.new(number: 1347,
                            title: 'Found a bug',
                            body: "I'm having a problem with this.")
        end

        let(:repo_options) { {} }
        let(:local_repo) { double('Git::Repository', current_issue: issue) }
        let(:context) do
          double(cli_options: cli_options,
                 local_repo?: true,
                 local_repo: local_repo,
                 repo_service: repo_service)
        end

        context 'with description' do
          let(:other_options) do
            { with_description: true }
          end

          it 'returns the issue' do
            expected_output = <<~END
              \e[31mFound a bug\e[0m
              I'm having a problem with this.
            END

            expect { subject.run }.to output(expected_output).to_stdout
          end
        end
      end
    end
  end
end
