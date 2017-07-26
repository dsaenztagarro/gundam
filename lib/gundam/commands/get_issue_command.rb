module Gundam
  class GetIssueCommand < Command
    def_delegators :context, :cli_options # base context
    def_delegators :context, :local_repo?, :local_repo, :repo_service,
      :repository # context with repository

    def run
      issue = if local_repo?
                local_repo.current_issue
              else
                repo_service.issue(repository, cli_options[:number])
              end
      issue.comments = repo_service.issue_comments(repository, issue.number)

      puts Gundam::IssueDecorator.new(issue).show_cli
    rescue Gundam::IssueNotFound => error
      Gundam::ErrorHandler.handle(error)
    rescue Platforms::Unauthorized => error
      puts ErrorDecorator.new(error)
    end
  end
end
