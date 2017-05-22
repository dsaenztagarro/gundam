require_relative 'command'
require 'pastel'

class GetIssueCommand < Command
  def run
    local_repo = LocalRepository.at(@base_dir)
    client     = local_repo.platform_client

    repo = local_repo.repository_name
    number = local_repo.current_branch.to_i
    issue = client.issue(repo, number)
    puts IssueDecorator.new(issue).to_s
  end
end
