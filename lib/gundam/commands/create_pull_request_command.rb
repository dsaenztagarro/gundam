require_relative 'command'

module Gundam
  class CreatePullRequestCommand < Command
    def run
      local_repo = LocalRepository.at(@base_dir)
      service = PlatformServiceFactory.
        with_platform(local_repo.platform_constant_name).build

      platform_repo = service.repository(local_repo.full_name)

      options = default_profile.pull_request_options(local_repo, platform_repo, service)

      pull_request = service.create_pull_request(options)

      `echo #{pull_request.html_url} | pbcopy`

      puts Gundam::PullRequestDecorator.new(pull_request).show_pull_created
    rescue Platforms::CreatePullRequestError,
           Platforms::Unauthorized => error
      puts ErrorDecorator.new(error)
    end
  end
end
