require_relative 'command'

module Gundam
  class GetPullRequestCommand < Command
    # @param [Hash] opts the options to get a pull request
    # @option opts [Boolean] :with_comments
    def run(options = {})
      local_repo = LocalRepository.at(@base_dir)
      service = PlatformServiceFactory.
        with_platform(local_repo.platform_constant_name).
        with_api_version('V3').
        build

      pull = begin
        if options[:number]
          service.pull_request(local_repo.full_name, options[:number])
        else
          service.pull_requests(local_repo.full_name, {
            status: 'open',
            head: "#{local_repo.owner}:#{local_repo.current_branch}"
          }).first
        end
      end
      if options[:with_comments]
        pull.comments = service.issue_comments(pull.head_repo_full_name, pull.number)
      end
      if options[:with_statuses]
        pull.statuses = service.statuses(pull.head_repo_full_name, pull.head_sha)
      end

      puts PullRequestDecorator.new(pull)
      pull.comments.each do |comment|
        puts IssueCommentDecorator.new(comment)
      end
      pull.statuses.each do |status|
        puts CommitStatusDecorator.new(status)
      end
    rescue Gundam::PullRequestNotFound => error
      Gundam::ErrorHandler.handle(error)
    end
  end
end
