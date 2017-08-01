module Gundam
  class GetIssueCommand < Command
    def_delegators :context, :repo_service, :repository # context with repository

    def run
      issue = IssueFinder.new(context).find
      issue.comments = repo_service.issue_comments(repository, issue.number)

      puts Gundam::IssueDecorator.new(issue).show_cli
    rescue Gundam::Unauthorized, Gundam::IssueNotFound => error
      Gundam::ErrorHandler.handle(error)
    end
  end
end
