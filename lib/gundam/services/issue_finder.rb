# frozen_string_literal: true

module Gundam
  class IssueFinder
    extend Forwardable

    def_delegators :@context, :cli_options # base context
    def_delegators :@context, :local_repo?, :local_repo, :repo_service,
                   :repository # context with repository

    def initialize(context)
      @context = context
    end

    # @param options [Hash] issue search options
    # @option option [Boolean] :expanded returns in addition comments
    def find(options = {})
      if local_repo?
        find_with_local_repo(options)
      else
        repo_service.issue(repository, cli_options[:number], options)
      end
    end

    private

    def find_with_local_repo(options)
      if issue_number
        local_repo.issue(issue_number, options)
      else
        local_repo.current_issue(options)
      end
    end

    def issue_number
      cli_options[:number]
    end
  end
end
