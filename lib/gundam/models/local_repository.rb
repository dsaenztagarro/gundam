# frozen_string_literal: true

module Gundam
  class LocalRepository < SimpleDelegator
    # @param options [Hash] issue search options
    # @option option [Boolean] :expanded returns in addition comments and
    #   combined status
    def current_pull(options = {})
      repo_service.pulls(owner, name, current_branch, options).last ||
        raise(PullRequestForBranchNotFound, current_branch)
    end

    # @param options [Hash] issue search options
    # @option option [Boolean] :with_comments
    def current_issue(options = {})
      issue_id = current_branch.to_i
      unless issue_id.positive?
        raise IssueNotFound, "Not found issue for branch #{current_branch}"
      end
      issue(issue_id, options)
    end

    # @param options [Hash] issue search options
    # @option option [Boolean] :with_comments
    def issue(number, options = {})
      repo_service.issue(owner, name, number, options)
    end

    def repo_service
      @repo_service ||= RepoServiceFactory.with_platform(platform_constant_name).build
    end

    class << self
      def at(dir)
        Dir.chdir(dir) do
          `git rev-parse --git-dir`
          return unless $CHILD_STATUS.exitstatus.zero?
          require_relative '../git/repository'
          git_repo = Git::Repository.new(dir)
          new(git_repo)
        end
      end
    end
  end
end
