# frozen_string_literal: true

require 'spec_helper'

describe Gundam::Commands::CreateComment do
  let(:repo_service) { double('RepoService') }
  let(:comment) { double('comment') }
  let(:subject) { described_class.new(context) }
  let(:issue_finder) { double(find: issue) }
  let(:issue) { double(number: 1) }

  let(:context) do
    double('FakeContext', command_options: { commentable: 'Issue' },
                          repository: 'octocat/Hello-World',
                          repo_service: repo_service)
  end

  let(:tmp_filepath) do
    "#{Gundam.base_dir}/files/octocat_Hello-World_issue_1_comment_20101115131020.md"
  end

  describe '#run' do
    before do
      time_now = with_utc_time_zone { Time.parse('2010-11-15 13:10:20').to_time }
      allow(Time).to receive(:now).and_return(time_now)
      File.delete(tmp_filepath) if File.exist?(tmp_filepath)

      allow(Gundam::IssueFinder).to receive(:new).with(context)
                                                 .and_return(issue_finder)

      allow(issue_finder).to receive(:find).and_return(issue)
    end

    it 'adds a comment to the issue when the user saves the file with text' do
      expect(subject).to receive(:system) do |arg|
        expect(arg).to eq("$EDITOR #{tmp_filepath}")
        # User saves the file with changes
        File.open(tmp_filepath, 'w') { |file| file.write('This is a comment') }
      end

      expect(repo_service).to receive(:add_comment)
        .with('octocat/Hello-World', 1, 'This is a comment')
        .and_return(Gundam::Comment.new(html_url: 'https://...'))

      expected_output = <<~OUT
        \e[32mhttps://...\e[0m
			OUT

      expect { subject.run }.to output(expected_output).to_stdout
    end

    it 'does not add a comment when the user saves the file empty' do
      expect(subject).to receive(:system) do |arg|
        expect(arg).to eq("$EDITOR #{tmp_filepath}")
      end

      expect(repo_service).to_not receive(:add_comment)

      subject.run
    end
  end
end
