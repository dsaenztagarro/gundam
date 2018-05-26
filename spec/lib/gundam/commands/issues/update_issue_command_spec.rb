# frozen_string_literal: true

require 'spec_helper'

describe Gundam::UpdateIssueCommand do
  let(:repo_service) { double('RepoService') }
  let(:comment)      { double('Comment') }
  let(:subject)      { described_class.new(context) }
  let(:issue_finder) { double('IssueFinder', find: issue) }
  let(:issue)        { create_issue }

  let(:context) do
    double('FakeContext', command_options: { commentable: 'Issue' },
                          repository: 'octocat/Hello-World',
                          repo_service: repo_service)
  end

  let(:tmp_filepath) do
    "#{Gundam.base_dir}/files/octocat_Hello-World_issues_1347_20101115131020.md"
  end

  describe '#run' do
    before do
      time_now = with_utc_time_zone { Time.parse('2010-11-15 13:10:20').to_time }
      allow(Time).to receive(:now).and_return(time_now)
      File.delete(tmp_filepath) if File.exist?(tmp_filepath)

      allow(Gundam::IssueFinder).to receive(:new).with(context)
                                                 .and_return(issue_finder)

      allow(issue_finder).to receive(:find).and_return(issue)

      expect(subject).to receive(:system) do |arg|
        expect(arg).to eq("$EDITOR #{tmp_filepath}")

        # EDITOR loaded with issue

        content_before_update = <<~OUT
          ---
          title: Found a bug
          assignees: octocat
          labels: bug, support
          ---
          I'm having a problem with this.
        OUT
        expect(File.read(tmp_filepath)).to eq(content_before_update)

        # EDITOR updated with user changes

        content_after_update = <<~OUT
          ---
          title: Found an urgent bug
          assignees: octocat
          labels: board:projects,urgent
          ---
          This is a recurrent error
        OUT
        File.open(tmp_filepath, 'w') { |file| file.write(content_after_update) }
      end
    end

    it 'updates the issue' do
      expect(repo_service).to receive(:update_issue)
        .with('octocat/Hello-World', issue).and_return(issue)

      expected_output = <<~END
        <uri>https://github.com/octocat/Hello-World/issues/1347</uri>
			END

      expect { subject.run }.to output(expected_output).to_stdout
    end

    context 'when metadata contains errors' do
      before do
        cause_error = double('OriginalError', message: 'Error reason')
        error = Gundam::UnprocessableEntity.new
        allow(error).to receive(:cause).and_return(cause_error)
        allow(repo_service).to receive(:update_issue).and_raise(error)
      end

      it 'raises an error' do
        expect { subject.run }.to raise_error(Gundam::UnprocessableEntity)
      end
    end
  end
end
