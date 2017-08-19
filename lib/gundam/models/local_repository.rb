module Gundam
  class LocalRepository < SimpleDelegator
    def current_pull
      head = "#{owner}:#{current_branch}"
      repo_service.pull_requests(full_name, status: 'open', head: head).last ||
        raise(PullRequestForBranchNotFound.new(head))
    end

    def current_issue
      issue(current_branch.to_i)
    end

    def issue(number)
      repo_service.issue(full_name, number)
    end

    def repo_service
      @repo_service ||= RepoServiceFactory.with_platform(platform_constant_name).build
    end

    class << self
      def at(dir)
        Dir.chdir(dir) do
          `git rev-parse --git-dir`
          return unless $CHILD_STATUS.exitstatus == 0
          git_repo = Git::Repository.new(dir)
          new(git_repo)
        end
      end
    end
  end
end
