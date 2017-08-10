require 'spec_helper'

describe Gundam::UpdatePullCommand do
  let(:repo_service) { double('RepoService') }
  let(:comment) { double('comment') }
  let(:subject) { described_class.new(context) }
  let(:pull_finder) { double(find: pull) }
  let(:pull) { double('Gundam::Pull', number: 2, body: 'My PR.') }

  let(:context) do
    double('FakeContext', command_options: { commentable: 'Pull' },
                          repository: 'octocat/Hello-World',
                          repo_service: repo_service)
  end

	let(:tmp_filepath) do
		"#{Gundam.base_dir}/files/octocat_Hello-World_pulls_2_20101115131020.md"
	end

	describe '#run' do
		before do
			time_now = with_utc_time_zone { Time.parse('2010-11-15 13:10:20').to_time }
			allow(Time).to receive(:now).and_return(time_now)
			File.delete(tmp_filepath) if File.exist?(tmp_filepath)

      allow(Gundam::PullFinder).to receive(:new).with(context)
        .and_return(pull_finder)

      allow(pull_finder).to receive(:find).and_return(pull)
		end

		it 'adds a comment to the pull when the user saves the file with text' do
			expect(subject).to receive(:system) do |arg|
				expect(arg).to eq("$EDITOR #{tmp_filepath}")
				# User saves the file with changes
        File.open(tmp_filepath, 'a') { |file| file.write(" Stop.") }
			end

			expect(repo_service).to receive(:update_pull_request).
        with('octocat/Hello-World', 2, 'My PR. Stop.').
				and_return(double('PullComment', html_url: 'https://...'))

			expected_output = <<~END
				\e[32mhttps://... (updated)\e[0m
			END

			expect { subject.run }.to output(expected_output).to_stdout
		end

		it 'does not add a comment when the user saves the file empty' do
			expect(subject).to receive(:system) do |arg|
				expect(arg).to eq("$EDITOR #{tmp_filepath}")
			end

			expect(repo_service).to_not receive(:update_pull_request)

			subject.run
		end
	end
end
