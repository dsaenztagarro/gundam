require 'spec_helper'

describe Gundam::CreateIssueCommand do
  let(:repo_service) { double('RepoService') }
  let(:comment)      { double('comment') }
  let(:subject)      { described_class.new(context) }
  let(:issue_finder) { double(find: issue) }
  let(:issue)        { Gundam::Issue.new(number: 2, body: 'My PR.') }

  let(:context) do
    double('FakeContext', command_options: { commentable: 'Issue' },
                          repository: 'octocat/Hello-World',
                          repo_service: repo_service)
  end

	let(:tmp_filepath) do
		"#{Gundam.base_dir}/files/octocat_Hello-World_issues_20101115131020.md"
	end

	describe '#run' do
		before do
			time_now = with_utc_time_zone { Time.parse('2010-11-15 13:10:20').to_time }
			allow(Time).to receive(:now).and_return(time_now)
			File.delete(tmp_filepath) if File.exist?(tmp_filepath)
		end

		it 'creates a new issue' do
			expect(subject).to receive(:system) do |arg|
				expect(arg).to eq("$EDITOR #{tmp_filepath}")

        template_content = <<~END
        ---
        title:
        labels:
        ---
        END
        expect(File.read(tmp_filepath)).to eq(template_content)

        user_content = <<~END
        ---
        title: Found a bug
        labels: board:products, bug
        ---
        I'm having a problem with this
        END
        File.open(tmp_filepath, 'w') { |file| file.write(user_content) }
			end

			expect(repo_service).to receive(:create_issue).
        with('octocat/Hello-World', 'Found a bug', "I'm having a problem with this\n", 'labels' => 'board:products, bug').
        and_return(Gundam::Issue.new(html_url: 'https://octocat/hello-world/issues/1'))

			expected_output = <<~END
        \e[32mhttps://octocat/hello-world/issues/1\e[0m
			END

			expect { subject.run }.to output(expected_output).to_stdout
		end
	end
end
