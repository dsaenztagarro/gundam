require_relative 'command'
require_relative 'shared/local_repo_ext'

module Gundam
  class GetPullRequestCommand < Command

    # @param [Hash] opts the options to get a pull request
    # @option opts [Fixnum] :number The pull request number
    # @option opts [Boolean] :with_description
    # @option opts [Boolean] :with_comments
    # @option opts [Boolean] :with_statuses
    def run(options = {})
      service = PlatformServiceFactory.
        with_platform(local_repo.platform_constant_name).
        with_api_version('V3').
        build

      pull = begin
        if options[:number]
          find_pull_by_number(options[:number])
        else
          local_repo.current_pull
        end
      end
      if options[:with_comments]
        pull.comments = service.issue_comments(pull.head_repo_full_name, pull.number)
      end
      if options[:with_statuses]
        pull.statuses = service.statuses(pull.head_repo_full_name, pull.head_sha)
      end

      puts Gundam::PullRequestDecorator.new(pull).show_pull(options)
    rescue Gundam::PullRequestNotFound,
           Gundam::PullRequestForBranchNotFound => error
      Gundam::ErrorHandler.handle(error)
    end

    private

    def local_repo
      @local_repo ||= LocalRepository.at(@base_dir)
    end

    def find_pull_by_number(number)
      local_repo.service.pull_request(local_repo.full_name, number)
    end
  end
end
