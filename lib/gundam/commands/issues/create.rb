# frozen_string_literal: true

module Gundam
  module Commands
    class CreateIssueCommand < Command
      include Shared::DecoratorHelper
      include Shared::FileHelper
      include Shared::IssueTemplate

      # def_delegators :context, :cli_options, :command_options # base context
      def_delegators :context, :repository, :repo_service # context with repository

      def run
        filepath = create_issue_file

        doc = edit_file(filepath)

        issue = create_issue(doc)

        puts decorate(issue).string_on_create
      end

      private

      def create_issue_file
        create_file(issue_filename, load_empty_template)
      end

      def issue_filename
        "#{file_repo}_issues_#{file_timestamp}.md"
      end

      def create_issue(doc)
        issue = decorate(Issue.new).update_attributes_from(doc)
        repo_service.create_issue(repository, issue)
      end
    end
  end
end
