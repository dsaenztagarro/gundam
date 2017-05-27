require_relative 'command'

class CreatePullRequestCommand < Command
  def run
    local_repo = LocalRepository.at(@base_dir)
    service = PlatformServiceFactory.new.
      with_platform(local_repo.platform_constant_name).build

    platform_repo = @spinner.spin "Find repo" do
      service.repository(local_repo.repository_name)
    end

    options = default_profile.pull_request_options(local_repo, platform_repo, service)

    pull_request = @spinner.spin "Create PR" do
      service.create_pull_request(options)
    end

    @spinner.spin "Save to clipboard" do
      `echo #{pull_request.html_url} | pbcopy`
    end

    puts pull_request.html_url
  rescue Platforms::CreatePullRequestError => error
    puts ErrorDecorator.new(error).to_s
  end
end
