# frozen_string_literal: true

require 'spec_helper'
require 'byebug'

describe Gundam::Commands::UpdateComment do
  let(:repo_service) { double('RepoService') }
  let(:comment)      { double('comment') }
  let(:subject)      { described_class.new(context) }
  let(:issue_finder) { double(find: issue) }
  let(:issue)        { double(number: 1) }

  let(:context) do
    double('Context', command_options: { commentable: 'Issue' },
                      cli_options: { comment_id: 319_887_731 },
                      # context with repository
                      repository: 'octocat/Hello-World',
                      repo_service: repo_service)
  end

  let(:tmp_filepath) do
    "#{Gundam.base_dir}/files/octocat_Hello-World_issue_1_comment_319887731_20101115131020.md"
  end

  describe '#run' do
    before do
      time_now = with_utc_time_zone { Time.parse('2010-11-15 13:10:20').to_time }
      allow(Time).to receive(:now).and_return(time_now)
      File.delete(tmp_filepath) if File.exist?(tmp_filepath)

      allow(Gundam::IssueFinder).to receive(:new).with(context)
                                                 .and_return(issue_finder)
      allow(issue_finder).to receive(:find).and_return(issue)

      allow(repo_service).to receive(:issue_comment)
        .with('octocat/Hello-World', 319_887_731)
        .and_return(double('Comment', body: 'Hello world.'))

      allow(repo_service).to receive(:update_comment)
        .with('octocat/Hello-World', 319_887_731, 'Hello world. Good bye')
        .and_return(Gundam::Comment.new(html_url: 'https://...'))
    end

    it 'updates the comment when the user saves the file with text' do
      expect(subject).to receive(:system) do |arg|
        expect(arg).to eq("$EDITOR #{tmp_filepath}")
        # User appends content to the comment
        File.open(tmp_filepath, 'a') { |file| file.write(' Good bye') }
      end

      expected_output = <<~OUTPUT
        <uri>https://...</uri>
			OUTPUT

      expect { subject.run }.to output(expected_output).to_stdout
    end

    it 'does not add a comment when the user saves the file empty' do
      expect(subject).to receive(:system) do |arg|
        expect(arg).to eq("$EDITOR #{tmp_filepath}")
        # User appends content to the comment
        File.open(tmp_filepath, 'a') { |file| file.write('') }
      end

      expect(repo_service).to_not receive(:update_comment)

      subject.run
    end
  end
end
