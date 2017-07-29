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

    context 'when Rest API V3' do
      let(:client) { double('Octokit::Client') }
      let(:repo_service) { Gundam::Github::API::V3::Gateway.new }

      before do
        allow(client).to receive(:issue).with('octocat/Hello-World', 1347).
          and_return(github_api_v3_response(:get_issue))

        allow(client).to receive(:issue_comments).
          with('octocat/Hello-World', 1347).
          and_return(github_api_v3_response(:get_issue_comments))

        allow(Gundam::Github::API::V3::Gateway).to receive(:new_client).
          and_return(client)
      end

      context 'without local repo' do
        let(:other_options) { { number: 1347 } }

        context 'and the number of issue exists' do
          it 'returns the issue' do
            expected_output = <<~END
              \e[31mFound a bug\e[0m
              I'm having a problem with this.
              \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m 1
              Me too
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

        it 'returns the issue with comments' do
          expected_output = <<~END
            \e[31mFound a bug\e[0m
            I'm having a problem with this.
            \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m 1
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
                 repository: 'octocat/Hello-World',
                 repo_service: repo_service)
        end

        it 'returns the issue' do
          expected_output = <<~END
            \e[31mFound a bug\e[0m
            I'm having a problem with this.
            \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m 1
            Me too
          END

          expect { subject.run }.to output(expected_output).to_stdout
        end
      end
    end
  end
end
