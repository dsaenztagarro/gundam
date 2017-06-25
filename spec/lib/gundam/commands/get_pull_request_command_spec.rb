require 'spec_helper'

describe Gundam::GetPullRequestCommand do
  let(:client) { double('Octokit::Client') }

  describe '#run' do
    before do
      allow(client).to \
        receive(:pull_requests).
        with('github/octocat', status: 'open', head: 'github:1-topic-branch').
        and_return(github_api_v3_response(:get_pull_requests))

      allow(Platforms::Github::API::V3::Connector).to \
        receive(:new_client).and_return(client)
    end

    context 'with description' do
      let(:options) do
        { with_description: true }
      end

      it 'returns the pull request' do
        change_to_git_repo_with_topic_branch do |repo_dir|
          command = described_class.new(base_dir: repo_dir)

          expected_output = <<~END
            \e[31mnew-feature\e[0m
            Please pull these awesome changes
          END

          expect { command.run(options) }.to output(expected_output).to_stdout
        end
      end
    end

    context 'without PR for current branch' do
      before do
        allow(client).to \
          receive(:pull_requests).
          with('github/octocat', status: 'open', head: 'github:1-topic-branch').
          and_return([])
      end

      it 'returns the pull request' do
        change_to_git_repo_with_topic_branch do |repo_dir|
          command = described_class.new(base_dir: repo_dir)

          expected_output = <<~END
						\e[31mNot found PR for branch github:1-topic-branch\e[0m
          END

          expect { command.run }.to output(expected_output).to_stdout
        end
      end
    end

    context 'with number and description' do
      let(:options) do
        { number: 1347, with_description: true }
      end

      context 'and number of pull exists' do
        before do
          allow(client).to receive(:pull_request).
            with('github/octocat', 1347).
            and_return(github_api_v3_response(:get_pull_requests).first)
        end

        it 'returns the pull request' do
          change_to_git_repo do |repo_dir|
            command = described_class.new(base_dir: repo_dir)

            expected_output = <<~END
              \e[31mnew-feature\e[0m
              Please pull these awesome changes
            END

            expect { command.run(options) }.to output(expected_output).to_stdout
          end
        end
      end

      context 'and the number of pull does not exist' do
        before do
          allow(client).to receive(:pull_request).and_raise(Octokit::NotFound)
        end

        it 'returns an error message to the user' do
          change_to_git_repo do |repo_dir|
            command = described_class.new(base_dir: repo_dir)

            expected_output = <<~END
              \e[31mNot found PR #1347 on github/octocat\e[0m
            END

            expect { command.run(options) }.to output(expected_output).to_stdout
          end
        end
      end
    end

    context 'with comments' do
      let(:options) do
        { with_comments: true }
      end

      before do
        allow(client).to receive(:issue_comments).
          with('octocat/Hello-World', 1347).
          and_return(github_api_v3_response :get_issue_comments)
      end

      it 'returns the pull request with comments' do
        change_to_git_repo_with_topic_branch do |repo_dir|
          command = described_class.new(base_dir: repo_dir)

          expected_output = <<~END
            \e[36moctocat\e[0m \e[34m2011-04-14T16:00:49Z\e[0m
            Me too
          END

          expect { command.run(options) }.to output(expected_output).to_stdout
        end
      end
    end

    context 'with statuses' do
      let(:options) do
        { with_statuses: true }
      end

      before do
        allow(client).to receive(:statuses).
          with('octocat/Hello-World', '6dcb09b5b57875f334f61aebed695e2e4193db5e').
          and_return(github_api_v3_response :get_commit_statuses)
      end

      it 'returns the pull request with commit statuses' do
        change_to_git_repo_with_topic_branch do |repo_dir|
          command = described_class.new(base_dir: repo_dir)

          expected_output = <<~END
            \e[32msuccess\e[0m \e[36mcontinuous-integration/jenkins\e[0m Build has completed successfully \e[34m2012-07-20T01:19:13Z\e[0m
          END

          expect { command.run(options) }.to output(expected_output).to_stdout
        end
      end
    end
  end
end
