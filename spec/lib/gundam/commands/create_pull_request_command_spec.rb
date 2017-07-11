require 'spec_helper'

describe Gundam::CreatePullRequestCommand do
  let(:local_repo) do
    double('Git::Repository', current_branch: '1-topic-branch',
                              full_name: 'octocat/Hello-World',
                              platform_constant_name: 'Github')
  end

  let(:context) { Gundam::CommandContext.new('/base/dir', {}) }
  let(:subject) { described_class.new(context) }

  before do
    allow(context).to receive(:local_repo).and_return(local_repo)
  end

  describe '#run' do
    context 'when Rest API V3' do
      let(:client) { double('Octokit::Client') }

      before do
        allow(Gundam::Github::API::V3::Gateway).to \
          receive(:new_client).and_return(client)
      end

      context 'and status 200 for GET operations' do
        before do
          allow(client).to receive(:repository)
            .with('octocat/Hello-World')
            .and_return(github_api_v3_response :get_repository)

          allow(client).to receive(:issue)
            .with('octocat/Hello-World', 1)
            .and_return(github_api_v3_response :get_issue)
        end

        context 'and PR is created' do
          before do
            allow(client).to receive(:create_pull_request)
              .with('octocat/Hello-World',
                    'master',
                    '1-topic-branch',
                    'Found a bug',
                    'This PR implements #1')
              .and_return(github_api_v3_response :create_pull_request)
          end

          it 'prints the url of the created PR' do
            expected_output = "\e[32mhttps://github.com/octocat/Hello-World/pull/1347\e[0m\n"

            expect { subject.run }.to output(expected_output).to_stdout
          end
        end

        context 'and there is an error creating PR' do
          before do
            allow(client).to \
              receive(:create_pull_request).and_raise(Octokit::Error)
          end

          it 'prints the error' do
            expected_output = "\e[31mOctokit::Error\e[0m\n"

            expect { subject.run }.to output(expected_output).to_stdout
          end
        end
      end

      context 'and status 401 on first GET operation' do
        before do
          allow(client).to receive(:repository).and_raise(Octokit::Unauthorized)
        end

        it 'prints the error' do
          expected_output = "\e[31mOctokit::Unauthorized\e[0m\n"

          expect { subject.run }.to output(expected_output).to_stdout
        end
      end
    end
  end
end
