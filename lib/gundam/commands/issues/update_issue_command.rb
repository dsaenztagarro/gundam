module Gundam
  class UpdateIssueCommand < Gundam::Command
    include Gundam::Commands::Shared::FileHelper

    def_delegators :context, :cli_options, :command_options # base context
    def_delegators :context, :repository, :repo_service # context with repository

    def run
      issue = IssueFinder.new(context).find
      original_text = issue.body

      filepath = create_file(edit_issue_filename(issue), original_text)

      new_text = edit_file(filepath)
      return if new_text.eql?(original_text)

      issue = repo_service.update_issue(repository, issue.number, new_text)

      puts Gundam::IssueDecorator.new(issue).string_on_update
    end

    private

    def edit_issue_filename(issue)
      repo = repository.tr('/', '_')
      "#{repo}_issues_#{issue.number}_#{file_timestamp}.md"
    end
  end
end
