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
      if with_comments?
        issue.comments = repo_service.issue_comments(repository, issue.number)
      end

      puts Gundam::IssueDecorator.new(issue).show_issue(cli_options)
    rescue Gundam::IssueNotFound => error
      Gundam::ErrorHandler.handle(error)
    rescue Platforms::Unauthorized => error
      puts ErrorDecorator.new(error)
    end

    private

    def with_comments?
      cli_options[:with_comments]
    end
  end
end
