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

      issue = create_issue_from(doc)

      puts decorate(issue).string_on_create
    end

    private

    def create_issue_file
      create_file(issue_filename, load_empty_template)
    end

    def issue_filename
      "#{file_repo}_issues_#{file_timestamp}.md"
    end

    def create_issue_from(doc)
      title   = doc.data['title']
      body    = doc.content
      options = doc.data.select { |key, _| key == 'labels' }
      repo_service.create_issue(repository, title, body, options)
    end
  end
end
