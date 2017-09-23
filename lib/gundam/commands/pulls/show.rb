module Gundam
  module Commands
    class ShowPullCommand < Command
      include Commands::Shared::DecoratorHelper

      def run
        pull = PullFinder.new(context).find(expanded: true)
        puts decorate(pull).string
      end
    end
  end
end
