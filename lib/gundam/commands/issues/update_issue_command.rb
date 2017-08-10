module Gundam
  class UpdateIssueCommand < Gundam::Command
    include Gundam::Commands::Shared::FileHelper

    def_delegators :context, :cli_options, :command_options # base context
    def_delegators :context, :repository, :repo_service # context with repository

    def run
      issue = find_issue
      original_text = issue.body

      filepath = create_file(edit_issue_filename(issue), original_text)

      new_text = edit_file(filepath)
      return if new_text.eql?(original_text)

      issue = update_issue(issue, new_text)

      puts decorate(issue).string_on_update
    end

    private

    def edit_issue_filename(issue)
      "#{file_repo}_issues_#{issue.number}_#{file_timestamp}.md"
    end

    def find_issue
      IssueFinder.new(context).find
    end

    def update_issue(issue, text)
      repo_service.update_issue(repository, issue.number, text)
    end

    def decorate(issue)
      Gundam::IssueDecorator.new(issue)
    end
  end
end
