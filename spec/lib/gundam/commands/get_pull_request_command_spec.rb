require 'spec_helper'

describe Gundam::GetPullRequestCommand do
  describe '#run' do
    let(:service) { Gundam::Github::API::V3::Gateway.new }
    let(:repo_options) { { without_local_repo: true, number: 1347 } }
    let(:other_options) { {} }
    let(:cli_options) { repo_options.merge(other_options) }
    let(:context) do
      double(cli_options: cli_options,
             local_repo?: false,
             repository: 'octocat/Hello-World',
             number: 1347,
             repo_service: service)
    end
    let(:subject) { described_class.new(context) }

    before do
      pull = Gundam::PullRequest.new(
        number: 1347,
        title: "new-feature",
        body: "Please pull these awesome changes",
        head_sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e")

      allow(service).to receive(:pull_request)
        .with('octocat/Hello-World', 1347).and_return(pull)

      allow(service).to receive(:issue_comments)
        .with('octocat/Hello-World', 1347).and_return([create_comment])

      statuses = [
        Gundam::CommitStatus.new(
          context: 'continuous-integration/jenkins',
          description: 'Build has completed successfully',
          state: 'success',
          updated_at: '2012-07-20T01:19:13Z')
      ]

      allow(service).to receive(:statuses)
        .with('octocat/Hello-World', '6dcb09b5b57875f334f61aebed695e2e4193db5e')
        .and_return(statuses)
    end

    context 'without local repo' do
      it 'returns the pull request' do
        expected_output = <<~END
          \e[31mnew-feature\e[0m
          Please pull these awesome changes
          \e[36moctokit\e[0m \e[34m2011-04-14 16:00:49 UTC\e[0m 318212279
          Me too
          \e[32msuccess\e[0m \e[36mcontinuous-integration/jenkins\e[0m Build has completed successfully \e[34m2012-07-20T01:19:13Z\e[0m
        END

        expect { subject.run }.to output(expected_output).to_stdout
      end
    end

    context "when there isn't a PR with passed number" do
      before do
        allow(service).to receive(:pull_request).
          with('octocat/Hello-World', 1347).
          and_raise Gundam::PullRequestNotFound.new('octocat/Hello-World', 1347)
      end

      it 'raises an error' do
        expected_output = <<~END
          \e[31mNot found PR #1347 on octocat/Hello-World\e[0m
        END

        expect { subject.run }.to output(expected_output).to_stdout
      end
    end

    context 'with local repo' do
      let(:pull) do
        Gundam::PullRequest.new(repository: 'octocat/Hello-World',
                                number: 1347,
                                title: 'new-feature',
                                body: 'Please pull these awesome changes',
                                head_sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e")
      end
      let(:local_repo) { double('Git::Repository', current_pull: pull) }
      let(:repo_options) { {} }
      let(:context) do
        double(cli_options: cli_options,
               local_repo?: true,
               local_repo: local_repo,
               repository: 'octocat/Hello-World',
               repo_service: service)
      end

      it 'returns the pull request' do
        expected_output = <<~END
          \e[31mnew-feature\e[0m
          Please pull these awesome changes
          \e[36moctokit\e[0m \e[34m2011-04-14 16:00:49 UTC\e[0m 318212279
          Me too
          \e[32msuccess\e[0m \e[36mcontinuous-integration/jenkins\e[0m Build has completed successfully \e[34m2012-07-20T01:19:13Z\e[0m
        END

        expect { subject.run }.to output(expected_output).to_stdout
      end

      context 'and local repo is not found' do
        before do
          error = Gundam::LocalRepoNotFound.new('/test/dir')
          allow(context).to receive(:local_repo).and_raise(error)
        end

        it 'raises an error' do
          expected_output = <<~END
            \e[31mNot found local repo at /test/dir\e[0m
          END

          expect { subject.run }.to output(expected_output).to_stdout
        end
      end

      context 'and pull from topic branch of local repo is not found' do
        before do
          error = Gundam::PullRequestForBranchNotFound.new('octocat:1-new-feature')
          allow(context).to receive(:local_repo).and_raise(error)
        end

        it 'raises an error' do
          expected_output = <<~END
            \e[31mNot found PR for branch octocat:1-new-feature\e[0m
          END

          expect { subject.run }.to output(expected_output).to_stdout
        end
      end
    end
  end
end
