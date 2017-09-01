module Gundam
  class CreatePullPlugin < Gundam::Plugin
    def_delegators :context, :repo_service, :local_repo # context with repository

    # @return [Hash]
    def pull_request_options
      branch_name = local_repo.current_branch
      issue_id    = branch_name.to_i

      remote_repo = repo_service.repository(local_repo.full_name)

      issue = repo_service.issue(remote_repo.owner, remote_repo.name, issue_id)

      { repo: remote_repo.full_name,
        base: remote_repo.default_branch,
        head: branch_name,
        title: issue.title,
        body: "This PR implements ##{issue_id}" }
    end
  end
end
