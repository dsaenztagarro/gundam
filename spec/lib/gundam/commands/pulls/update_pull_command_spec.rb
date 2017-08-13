require 'spec_helper'

describe Gundam::UpdatePullCommand do
  let(:repo_service) { double('RepoService') }
  let(:comment)      { double('comment') }
  let(:subject)      { described_class.new(context) }
  let(:pull_finder)  { double(find: pull) }
  let(:pull)         { create_pull_request }

  let(:context) do
    double('FakeContext', command_options: { commentable: 'Pull' },
                          repository: 'octocat/Hello-World',
                          repo_service: repo_service)
  end

	let(:tmp_filepath) do
		"#{Gundam.base_dir}/files/octocat_Hello-World_pullrequests_1347_20101115131020.md"
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

		it 'update the pull' do
			expect(subject).to receive(:system) do |arg|
				expect(arg).to eq("$EDITOR #{tmp_filepath}")

				# EDITOR loaded with pull

        content_before_update = <<~END
        ---
        title: new-feature
        ---
        Please pull these awesome changes
        END
        expect(File.read(tmp_filepath)).to eq(content_before_update)

				# EDITOR updated with user changes

        content_after_update = <<~END
        ---
        title: new-modified-feature
        ---
        Please pull these awesome changes. Thanks.
        END
        File.open(tmp_filepath, 'w') { |file| file.write(content_after_update) }
			end

      expect(repo_service).to receive(:update_pull_request)
        .with('octocat/Hello-World', pull).and_return(pull)

			expected_output = <<~END
				\e[32mhttps://github.com/octocat/Hello-World/pull/1347\e[0m
			END

			expect { subject.run }.to output(expected_output).to_stdout
		end
	end
end
