module Gundam
  class ShowIssueCommand < Command
    include Commands::Shared::DecoratorHelper

    def_delegators :context, :repo_service, :repository # context with repository

    def run
      issue = IssueFinder.new(context).find
      issue.comments = repo_service.issue_comments(repository, issue.number)

      puts decorate(issue).string
    rescue Gundam::Unauthorized, Gundam::IssueNotFound => error
      Gundam::ErrorHandler.handle(error)
    end
  end
end
