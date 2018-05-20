# frozen_string_literal: true

module Gundam
  class UpdatePullCommand < UpdateIssueCommand
    private

    def find_issue
      PullFinder.new(context).find
    end

    def update_issue(issue)
      repo_service.update_pull_request(repository, issue)
    end

    def load_template_from(pull)
      body   = pull.body
      title  = pull.title
      renderer = ERB.new(get_template)
      renderer.result(binding)
    end

    def get_template
      <<~TEMPLATE
        ---
        title: <%= title %>
        ---
        <%= body %>
      TEMPLATE
    end
  end
end
