class LocalRepository < SimpleDelegator
  def current_pull
    head = "#{owner}:#{current_branch}"
    service.pull_requests(full_name, status: 'open', head: head).last ||
      raise(Gundam::PullRequestForBranchNotFound.new(head))
  end

  def current_issue
    service.issue(full_name, current_branch.to_i).tap do |issue|
      issue.repository = full_name
    end
  end

  def service
    @service ||= Gundam::RepoServiceFactory.with_platform(platform_constant_name).build
  end

  class << self
    def at(dir)
      Dir.chdir(dir) do
        `git rev-parse --git-dir`
        return unless $CHILD_STATUS.exitstatus == 0
        git_repo = Gundam::Git::Repository.new(dir)
        new(git_repo)
      end
    end
  end
end
