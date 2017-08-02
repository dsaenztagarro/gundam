module Gundam
  class GetPullRequestCommand < Command
    def_delegators :context, :repo_service, :repository # context with repository

    def run
      pull = PullFinder.new(context).find
      pull.comments = repo_service.issue_comments(repository, pull.number)
      pull.statuses = repo_service.statuses(repository, pull.head_sha)

      puts Gundam::PullRequestDecorator.new(pull).show_pull
    rescue Gundam::LocalRepoNotFound,
           Gundam::PullRequestNotFound,
           Gundam::PullRequestForBranchNotFound => error
      Gundam::ErrorHandler.handle(error)
    end
  end
end
