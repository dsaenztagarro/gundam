require 'spec_helper'
require 'byebug'

describe Gundam::Commands::Issue::AddComment do
  let(:service) { double('Gundam::Github::Service') }
  let(:comment) { double('comment') }

  let(:context) do
    Gundam::CommandContext.new(
      repository: 'github/octocat',
      number: 1,
      service: service
    )
  end

	let(:tmp_filepath) do
		"#{Gundam.base_dir}/files/github_octocat_issue_1_comment_20101115131020.md"
	end

	describe '#run' do
		before do
			time_now = with_utc_time_zone { Time.parse('2010-11-15 13:10:20').to_time }
			allow(Time).to receive(:now).and_return(time_now)
			File.delete(tmp_filepath) if File.exist?(tmp_filepath)
		end

		it 'adds a comment to the issue when the user saves the file with text' do
			expect(subject).to receive(:system) do |arg|
				expect(arg).to eq("$EDITOR #{tmp_filepath}")
				# User saves the file with changes
				File.open(tmp_filepath, 'w') { |file| file.write("This is a comment") }
			end

			expect(service).to \
				receive(:add_comment).
				with('github/octocat', 1, 'This is a comment').
				and_return(double('IssueComment', html_url: 'https://...'))

			expected_output = <<~END
				\e[32mhttps://...\e[0m
			END

			expect { subject.run(context) }.to output(expected_output).to_stdout
		end

		it 'does not add a comment when the user saves the file empty' do
			expect(subject).to receive(:system) do |arg|
				expect(arg).to eq("$EDITOR #{tmp_filepath}")
			end

			expect(service).to_not receive(:add_comment)

			subject.run(context)
		end
	end
end
