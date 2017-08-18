module Gundam
  class UpdateIssueCommand < Command
    include Commands::Shared::DecoratorHelper
    include Commands::Shared::FileHelper
    include Commands::Shared::IssueTemplate

    def_delegators :context, :cli_options, :command_options # base context
    def_delegators :context, :repository, :repo_service # context with repository

    def run
      issue = find_issue

      filepath = load_file_for(issue)

      doc = edit_file(filepath)
      decorate(issue).update_attributes_from(doc)

      issue = update_issue(issue)

      puts decorate(issue).string_on_update
    rescue Gundam::UnprocessableEntity => error
      Gundam::ErrorHandler.handle(error)
    end

    private

    def find_issue
      IssueFinder.new(context).find
    end

    def load_file_for(issue)
      create_file(issue_filename(issue), load_template_from(issue))
    end

    def issue_filename(issue)
      class_name = issue.class.name.split('::').pop.downcase
      "#{file_repo}_#{class_name}s_#{issue.number}_#{file_timestamp}.md"
    end

    def update_issue(issue)
      repo_service.update_issue(repository, issue)
    end
  end
end
