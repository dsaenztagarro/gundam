require 'spec_helper'

describe Gundam::CreatePullCommand do
	let(:repo_service) { double('Gundam::Github::API::V3::Gateway') }
  let(:local_repo) { double('Git::Repository') }
  let(:context) do
		double('Gundam::Context', local_repo: local_repo,
															repo_service: repo_service)
	end

	let(:plugin) { double('Gundam::Plugin') }
	let(:decorator) { double('Gundam::PullRequestDecorator') }

  let(:subject) { described_class.new(context) }

	let(:pr_options) { double('options') }
	let(:pull_request) { create_pull_request }

  describe '#run' do
		before do
			allow(Gundam::CreatePullPlugin).to receive(:new).with(context)
				.and_return(plugin)
			allow(plugin).to receive(:pull_request_options).and_return(pr_options)

			allow(Gundam::PullRequestDecorator).to receive(:new).with(pull_request)
				.and_return(decorator)
		end

    context 'when the upstream is present' do
			before do
				allow(local_repo).to receive(:exist_remote_branch?).and_return(true)
			end

      it 'creates the pull request' do
				expect(repo_service).to receive(:create_pull_request).with(pr_options)
					.and_return(pull_request)

				expect(subject).to receive(:`).with('echo https://github.com/octocat/Hello-World/pull/1347 | pbcopy')

				expect(decorator).to receive(:show_pull_created)

				subject.run
			end

      context 'and there is an error creating PR' do
        before do
          cause_error = double('OriginalError', message: 'Error reason')
          error = Gundam::CreatePullRequestError.new
          allow(error).to receive(:cause).and_return(cause_error)
          allow(repo_service).to receive(:create_pull_request).and_raise(error)
        end

        it 'prints the error' do
          expected_output = "\e[31mError reason\e[0m\n"

          expect { subject.run }.to output(expected_output).to_stdout
        end
      end

			context 'and status 401 on first GET operation' do
				before do
					allow(plugin).to receive(:pull_request_options)
						.and_raise(Gundam::Unauthorized.new(:github_api_v3))
				end

				it 'prints the error' do
					expected_output = "\e[31mUnauthorized access to Github REST API V3\e[0m\n"

					expect { subject.run }.to output(expected_output).to_stdout
				end
			end
    end

    context 'when the upstream is present' do
      before do
        allow(local_repo).to receive(:exist_remote_branch?).and_return(false)
      end

      it 'creates the pull request' do
        expect(local_repo).to receive(:push_set_upstream)

        expect(repo_service).to receive(:create_pull_request).with(pr_options)
          .and_return(pull_request)

        expect(subject).to receive(:`).with('echo https://github.com/octocat/Hello-World/pull/1347 | pbcopy')

        expect(decorator).to receive(:show_pull_created)

        subject.run
      end
    end
	end
end