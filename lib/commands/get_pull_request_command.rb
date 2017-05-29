require_relative 'command'

class GetPullRequestCommand < Command
  def run
    local_repo = LocalRepository.at(@base_dir)
    service = PlatformServiceFactory.
      with_platform(local_repo.platform_constant_name).
      with_api_version('V3').
      build

    pull_requests = service.pull_requests(local_repo.full_name, {
      status: 'open',
      head: "#{local_repo.owner}:#{local_repo.current_branch}"
    })

    pull_requests.each do |pull_request|
      puts PullRequestDecorator.new(pull_request)
    end
  end
end
