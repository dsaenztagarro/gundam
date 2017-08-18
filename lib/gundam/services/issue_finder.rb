require 'byebug'

module Gundam
  class IssueFinder
    extend Forwardable
    def_delegators :@context, :cli_options # base context
    def_delegators :@context, :local_repo?, :local_repo, :repo_service,
      :repository # context with repository

    def initialize(context)
      @context = context
    end

    def find
      if local_repo?
        local_repo.current_issue
      else
        repo_service.issue(repository, cli_options[:number])
      end
    end
  end
end
