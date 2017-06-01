require_relative 'command'

class GetPullRequestCommand < Command
  # @param [Hash] opts the options to get a pull request
  # @option opts [Boolean] :with_comments
  def run(options = {})
    local_repo = LocalRepository.at(@base_dir)
    service = PlatformServiceFactory.
      with_platform(local_repo.platform_constant_name).
      with_api_version('V3').
      build

    pull_requests = service.pull_requests(local_repo.full_name, {
      status: 'open',
      head: "#{local_repo.owner}:#{local_repo.current_branch}"
    })

    pull_requests.each do |pr|
      puts PullRequestDecorator.new(pr)

      if options[:with_comments]
        comments = service.issue_comments(pr.head_repo_full_name, pr.number)
        comments.each do |comment|
          puts IssueCommentDecorator.new(comment)
        end
      end

      if options[:with_statuses]
        statuses = service.statuses(pr.head_repo_full_name, pr.head_sha)
        statuses.each do |status|
          puts CommitStatusDecorator.new(status)
        end
      end
    end
  end
end
