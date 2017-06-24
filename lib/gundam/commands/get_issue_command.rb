require_relative 'command'

module Gundam
  class GetIssueCommand < Command
    # @param [Hash] opts the options to get a pull request
    # @option opts [Fixnum] :number The issue number
    # @option opts [Boolean] :with_comments
    def run(options = {})
      local_repo = LocalRepository.at(@base_dir)
      service = PlatformServiceFactory.
        with_platform(local_repo.platform_constant_name).build

      number = options[:number] || local_repo.current_branch.to_i

      issue = service.issue(local_repo.full_name, number)
      if options[:with_comments]
        issue.comments = service.issue_comments(local_repo.full_name, number)
      end

      puts Gundam::IssueDecorator.new(issue).show_issue(options)
    rescue Gundam::IssueNotFound => error
      Gundam::ErrorHandler.handle(error)
    rescue Platforms::Unauthorized => error
      puts ErrorDecorator.new(error)
    end
  end
end
