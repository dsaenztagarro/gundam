# frozen_string_literal: true

module Gundam
  class CreatePullCommand < Command
    include Commands::Shared::DecoratorHelper

    def_delegators :context, :repo_service, :local_repo # context with repository

    def run
      local_repo.push_set_upstream unless local_repo.exist_remote_branch?

      options = plugin.pull_request_options

      pull = repo_service.create_pull_request(options)

      `echo #{pull.html_url} | pbcopy`

      puts decorate(pull).string_on_create
    rescue Gundam::Unauthorized, Gundam::CreatePullRequestError => error
      Gundam::ErrorHandler.handle(error)
    end

    def plugin
      Gundam::CreatePullPlugin.new(context)
    end
  end
end
