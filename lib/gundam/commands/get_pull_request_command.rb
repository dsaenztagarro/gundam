module Gundam
  class GetPullRequestCommand < Command
    def_delegators :context, :cli_options # base context
    def_delegators :context, :local_repo?, :local_repo, :repo_service,
      :repository # context with repository

    def run
      pull = if local_repo?
               local_repo.current_pull
             else
               repo_service.pull_request(repository, cli_options[:number])
             end
      if cli_options[:with_comments]
        pull.comments = repo_service.issue_comments(repository, pull.number)
      end
      if cli_options[:with_statuses]
        pull.statuses = repo_service.statuses(repository, pull.head_sha)
      end

      puts Gundam::PullRequestDecorator.new(pull).show_pull(cli_options)
    rescue Gundam::LocalRepoNotFound,
           Gundam::PullRequestNotFound,
           Gundam::PullRequestForBranchNotFound => error
      Gundam::ErrorHandler.handle(error)
    end
  end
end
