require_relative 'command'

class GetIssueCommand < Command
  # @param [Hash] opts the options to get a pull request
  # @option opts [Boolean] :with_comments
  def run(options = {})
    local_repo = LocalRepository.at(@base_dir)
    service = PlatformServiceFactory.
      with_platform(local_repo.platform_constant_name).build

    number = local_repo.current_branch.to_i

    issue = service.issue(local_repo.full_name, number)
    puts IssueDecorator.new(issue).to_s

    if options[:with_comments]
      comments = service.issue_comments(local_repo.full_name, number)
      comments.each do |comment|
        puts IssueCommentDecorator.new(comment)
      end
    end
  rescue Platforms::Unauthorized => error
    puts ErrorDecorator.new(error)
  end
end
