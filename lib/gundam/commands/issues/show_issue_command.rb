# frozen_string_literal: true

module Gundam
  class ShowIssueCommand < Command
    include Commands::Shared::DecoratorHelper

    def run
      issue = IssueFinder.new(context).find(with_comments: true)
      puts decorate(issue).to_stdout
    end
  end
end
