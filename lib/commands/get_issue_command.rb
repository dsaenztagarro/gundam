require_relative 'command'

class GetIssueCommand < Command
  def run
    local_repo = LocalRepository.at(@base_dir)
    service = PlatformServiceFactory.
      with_platform(local_repo.platform_constant_name).build

    number = local_repo.current_branch.to_i
    issue = service.issue(local_repo.full_name, number)
    puts IssueDecorator.new(issue).to_s
  end
end
