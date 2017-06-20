require_relative 'command'

module Gundam
  class CreatePullRequestCommand < Command
    def run
      local_repo = LocalRepository.at(@base_dir)
      service = PlatformServiceFactory.
        with_platform(local_repo.platform_constant_name).build

      platform_repo = @spinner.spin "Find repo" do
        service.repository(local_repo.full_name)
      end

      options = default_profile.pull_request_options(local_repo, platform_repo, service)

      pull_request = @spinner.spin "Create PR" do
        service.create_pull_request(options)
      end

      @spinner.spin "Save to clipboard" do
        `echo #{pull_request.html_url} | pbcopy`
      end

      puts PullRequestDecorator.new(pull_request).to_s_on_success_created

    rescue Platforms::CreatePullRequestError,
           Platforms::Unauthorized => error
      puts ErrorDecorator.new(error)
    end
  end
end
