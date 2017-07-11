require 'spec_helper'

describe Gundam::GetIssueCommand do
  describe '#run' do
    let(:original_options) { {} }
    let(:context) do
      Gundam::CommandContext.new(
        original_options: original_options,
        repository: 'github/octocat',
        number: 1,
        service: service)
    end

    context 'when GraphQL API V4' do
      let(:service) { Gundam::Github::API::V4::Gateway.new }

      before { WebMock.disable_net_connect! }

      context 'and status 200' do
        before { stub_github_api_v4_request(:issue) }

        context 'with description and comments' do
          let(:original_options) do
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

            expect { subject.run(context) }.to output(expected_output).to_stdout
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

        expect { subject.run(context) }.to output(expected_output).to_stdout
      end
    end

    context 'when Rest API V3' do
      let(:client) { double('Octokit::Client') }
      let(:service) { Gundam::Github::API::V3::Gateway.new }

      before do
        allow(client).to receive(:issue).with('github/octocat', 1).
          and_return(github_api_v3_response :get_issue)

        allow(Gundam::Github::API::V3::Gateway).to receive(:new_client).
          and_return(client)
      end

      context 'with description' do
        let(:original_options) do
          { with_description: true }
        end

        it 'returns the issue' do
          expected_output = <<~END
            \e[31mFound a bug\e[0m
            I'm having a problem with this.
          END

          expect { subject.run(context) }.to output(expected_output).to_stdout
        end
      end

      context 'with number and description' do
        let(:original_options) do
          { number: 1, with_description: true }
        end

        context 'and the number of issue exists' do
          it 'returns the issue' do
            expected_output = <<~END
              \e[31mFound a bug\e[0m
              I'm having a problem with this.
            END

            expect { subject.run(context) }.to output(expected_output).to_stdout
          end
        end

        context 'and the number of issue does not exist' do
          before do
            allow(client).to receive(:issue).and_raise(Octokit::NotFound)
          end

          it 'returns an error message to the user' do
            expected_output = <<~END
              \e[31mNot found issue #1 on github/octocat\e[0m
            END

            expect { subject.run(context) }.to output(expected_output).to_stdout
          end
        end
      end

      context 'with description and comments' do
        let(:original_options) do
          { with_description: true, with_comments: true }
        end

        before do
          allow(client).to receive(:issue_comments).
            with('github/octocat', 1).
            and_return(github_api_v3_response :get_issue_comments)
        end

        it 'returns the issue with comments' do
          expected_output = <<~END
          \e[31mFound a bug\e[0m
          I'm having a problem with this.
          \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m
          Me too
          END

          expect { subject.run(context) }.to output(expected_output).to_stdout
        end
      end
    end
  end
end
