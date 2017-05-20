require_relative 'command'

class CreatePullRequestCommand < Command
  def run
    local_repo = LocalRepository.at(@base_dir)
    client     = local_repo.platform_client

    platform_repo = @spinner.spin "Find repo" do
      client.repository(local_repo.repository_name)
    end

    options = default_profile.pull_request_options(local_repo, platform_repo, client)

    pull_request = @spinner.spin "Create PR" do
      client.create_pull_request(options)
    end

    @spinner.spin "Save to clipboard" do
      `echo #{pull_request.html_url} | pbcopy`
    end

    puts "\n #{pull_request.html_url}"
  rescue Platforms::CreatePullRequestError => error
    puts "\n#{error.cause.message}"
  end
end
