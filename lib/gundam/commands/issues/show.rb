# frozen_string_literal: true

module Gundam
  module Commands
    class ShowIssueCommand < Command
      include Commands::Shared::DecoratorHelper

      def run
        issue = IssueFinder.new(context).find(with_comments: true)
        puts decorate(issue).string
      end
    end
  end
end
