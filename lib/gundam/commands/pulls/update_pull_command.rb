module Gundam
  class UpdatePullCommand < UpdateIssueCommand

    private

    def issue_filename(pull)
      "#{file_repo}_pulls_#{pull.number}_#{file_timestamp}.md"
    end

    def find_issue
      PullFinder.new(context).find
    end

    def decorate(pull)
      Gundam::PullRequestDecorator.new(pull)
    end

    def update_issue(issue, text)
      repo_service.update_pull_request(repository, issue.number, text)
    end
  end
end
