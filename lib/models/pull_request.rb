class PullRequest
  attr_reader \
    :body,
    :created_at,
    :created_by,
    :head_repo_full_name,
    :head_sha,
    :html_url,
    :number,
    :source_branch,
    :target_branch,
    :title,
    :updated_at

  attr_accessor :comments, :statuses

  def initialize(
      body:,
      created_at:,
      created_by:,
      head_repo_full_name:,
      head_sha:,
      html_url:,
      number:,
      source_branch:,
      target_branch:,
      title:,
      updated_at:
    )
    @body          = body
    @created_at    = created_at
    @created_by    = created_by
    @head_repo_full_name = head_repo_full_name
    @head_sha      = head_sha
    @html_url      = html_url
    @number        = number
    @source_branch = source_branch
    @target_branch = target_branch
    @title         = title
    @updated_at    = updated_at
    @comments      = []
    @statuses      = []
  end
end
