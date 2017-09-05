# frozen_string_literal: true

module Gundam
  class CreatePullPlugin < Gundam::Plugin
    def_delegators :context, :repo_service, :local_repo # context with repository

    # @return [Hash]
    def pull_request_options
      remote_repo = repo_service.repository(local_repo.full_name)

      issue = IssueFinder.new(context).find

      { repo: remote_repo.full_name,
        base: remote_repo.default_branch,
        head: local_repo.current_branch,
        title: issue.title,
        body: "This PR implements ##{issue.number}" }
    end
  end
end
