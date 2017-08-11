module Gundam
  class CreateIssueCommand < Gundam::Command
    include Gundam::Commands::Shared::FileHelper

    def_delegators :context, :cli_options, :command_options # base context
    def_delegators :context, :repository, :repo_service # context with repository

    def run
      filepath = create_file(issue_filename)

      raw_text = edit_file(filepath)
      return if text.empty?

      text, metadata = extract_file(raw_text)

      issue = create_issue(issue, new_text)

      puts decorate(issue).string_on_create
    end

    private

    def issue_filename
      "#{file_repo}_issues_#{file_timestamp}.md"
    end

    def create_issue(issue, text)
      repo_service.create_issue(repository, title, body)
    end

    def decorate(issue)
      Gundam::IssueDecorator.new(issue)
    end

    def extract_file(raw_text)
      debugger
    end
  end
end
