# frozen_string_literal: true

module Gundam
  class CreateIssueCommand < Command
    include Commands::Shared::DecoratorHelper
    include Commands::Shared::FileHelper
    include Commands::Shared::IssueTemplate

    def_delegators :context, :cli_options, :command_options # base context
    def_delegators :context, :repository, :repo_service # context with repository

    def run
      filepath = create_issue_file

      doc = edit_file(filepath)
      issue = decorate(Issue.new).update_attributes_from(doc)

      issue = repo_service.create_issue(repository, issue)

      puts decorate(issue).string_on_create
    end

    private

    def create_issue_file
      create_file(issue_filename, load_empty_template)
    end

    def issue_filename
      "#{file_repo}_issues_#{file_timestamp}.md"
    end
  end
end
