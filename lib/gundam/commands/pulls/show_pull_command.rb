# frozen_string_literal: true

module Gundam
  class ShowPullCommand < Command
    include Commands::Shared::DecoratorHelper

    def run
      pull = PullFinder.new(context).find(expanded: true)
      puts decorate(pull).to_stdout
    end
  end
end
