require_relative 'command'

class GetIssueCommand < Command
  def run
    local_repo = LocalRepository.at(@base_dir)
    service = PlatformServiceFactory.new.
      with_platform(local_repo.platform_constant_name).build

    repo = local_repo.repository_name
    number = local_repo.current_branch.to_i
    issue = service.issue(repo, number)
    puts IssueDecorator.new(issue).to_s
  end
end
