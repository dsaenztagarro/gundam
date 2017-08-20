module Gundam
  class ShowIssueCommand < Command
    include Commands::Shared::DecoratorHelper

    def run
      issue = IssueFinder.new(context).find(with_comments: true)
      puts decorate(issue).string
    rescue Gundam::Unauthorized, Gundam::IssueNotFound => error
      Gundam::ErrorHandler.handle(error)
    end
  end
end
