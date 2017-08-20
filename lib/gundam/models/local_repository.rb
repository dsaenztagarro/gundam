module Gundam
  class LocalRepository < SimpleDelegator
    # @param options [Hash] issue search options
    # @option option [Boolean] :expanded returns in addition comments and
    #   combined status
    def current_pull(options = {})
      head = "#{owner}:#{current_branch}"
      repo_service.pulls(owner, name, current_branch, options).last ||
        raise(PullRequestForBranchNotFound.new(current_branch))
    end

    # @param options [Hash] issue search options
    # @option option [Boolean] :with_comments
    def current_issue(options = {})
      issue(current_branch.to_i, options)
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
          return unless $CHILD_STATUS.exitstatus == 0
          require_relative '../git/repository'
          git_repo = Git::Repository.new(dir)
          new(git_repo)
        end
      end
    end
  end
end
