module Gundam
  class CreatePullRequestCommand < Command
    def_delegators :context, :repo_service, :local_repo # context with repository

    def run
      local_repo.push_set_upstream unless local_repo.exist_remote_branch?

      options = plugin.pull_request_options

      pull_request = repo_service.create_pull_request(options)

      `echo #{pull_request.html_url} | pbcopy`

      puts Gundam::PullRequestDecorator.new(pull_request).show_pull_created
    rescue Gundam::Unauthorized, Gundam::CreatePullRequestError => error
      Gundam::ErrorHandler.handle(error)
    end

    def plugin
      Gundam::CreatePullRequestPlugin.new(context)
    end
  end
end
