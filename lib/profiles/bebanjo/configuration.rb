module Profiles
  module Bebanjo
    class Configuration
      def initialize(spinner)
        @spinner = spinner
      end

      # @param git_repo [Git::Repository]
      # @param github_repo [Github::Repository]
      # @param client [Github::Client]
      # @return [Hash]
      def pull_request_options(git_repo, platform_repo, client)
        branch_name = git_repo.current_branch
        issue_id    = branch_name.to_i

        issue = @spinner.spin "Find issue" do
          client.issue(platform_repo.name, issue_id)
        end

        { repo: platform_repo.name,
          base: platform_repo.default_branch,
          head: branch_name,
          title: issue.title,
          body: "This PR implements ##{issue_id}" }
      end
    end
  end
end
