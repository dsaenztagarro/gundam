require_relative 'command'

class GetIssueCommentsCommand < Command
  def run
    local_repo = LocalRepository.at(@base_dir)
    service = PlatformServiceFactory.
      with_platform(local_repo.platform_constant_name).with_api_version(:V4).
      build

    repo = local_repo.repository_name
    number = local_repo.current_branch.to_i
    comments = service.issue_comments(repo, number)
    comments.each { |comment|
      puts IssueCommentDecorator.new(comment)
    }
  rescue Platforms::Unauthorized => error
    puts ErrorDecorator.new(error)
  end
end
