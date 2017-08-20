module Gundam
  class ShowPullCommand < Command
    include Commands::Shared::DecoratorHelper

    def run
      pull = PullFinder.new(context).find(expanded: true)
      puts decorate(pull).string
    rescue Gundam::LocalRepoNotFound,
           Gundam::PullNotFound,
           Gundam::PullRequestForBranchNotFound => error
      Gundam::ErrorHandler.handle(error)
    end
  end
end
