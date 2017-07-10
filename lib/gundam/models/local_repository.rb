class LocalRepository < SimpleDelegator

  def current_pull
    head = "#{owner}:#{current_branch}"
    service.pull_requests(full_name, status: 'open', head: head).last ||
      raise(Gundam::PullRequestForBranchNotFound.new(head))
  end

  def service
    @service ||= PlatformServiceFactory.with_platform(platform_constant_name).build
  end

  class << self
    def at(dir)
      Dir.chdir(dir) do
        `git rev-parse --git-dir`
        return unless $?.exitstatus == 0
        git_repo = Git::Repository.new(dir)
        new(git_repo)
      end
    end
  end
end
