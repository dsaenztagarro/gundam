module Profiles
  module Bebanjo
    class Configuration
      # @param git_repo [Git::Repository]
      # @param github_repo [Github::Repository]
      # @param service [Github::Service]
      # @return [Hash]
      def pull_request_options(git_repo, platform_repo, service)
        branch_name = git_repo.current_branch
        issue_id    = branch_name.to_i

        issue = service.issue(platform_repo.full_name, issue_id)

        { repo: platform_repo.full_name,
          base: platform_repo.default_branch,
          head: branch_name,
          title: issue.title,
          body: "This PR implements ##{issue_id}" }
      end
    end
  end
end
