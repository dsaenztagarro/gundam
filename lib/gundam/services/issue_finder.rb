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
        find_with_local_repo
      else
        repo_service.issue(repository, cli_options[:number])
      end
    end

    private

    def find_with_local_repo
      if issue_number
        local_repo.issue(issue_number)
      else
        local_repo.current_issue
      end
    end

    def issue_number
      cli_options[:number]
    end
  end
end
