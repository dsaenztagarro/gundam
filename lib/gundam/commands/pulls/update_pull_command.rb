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
      title  = pull.title
      body   = pull.body
      renderer = ERB.new(get_template)
      renderer.result(binding)
    end

    def get_template
      <<~END
        ---
        title: <%= title %>
        ---
        <%= body %>
      END
    end
  end
end
