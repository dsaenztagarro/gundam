require_relative 'command'

class GetIssueCommentsCommand < Command
  def run
    local_repo = LocalRepository.at(@base_dir)
    client     = local_repo.platform_client

    repo = local_repo.repository_name
    number = local_repo.current_branch.to_i
    comments = client.issue_comments(repo, number)
    comments.each { |comment| print(comment) }
  end

  private

  def print(comment)
    puts "> [#{comment.user_login}] (#{comment.updated_at})"
    puts "  #{comment.body}"
    puts
  end
end
