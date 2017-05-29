class PullRequest
  attr_reader \
    :body,
    :created_at,
    :created_by,
    :html_url,
    :number,
    :source_branch,
    :target_branch,
    :title,
    :updated_at

  def initialize(
      body:,
      created_at:,
      created_by:,
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
    @html_url      = html_url
    @number        = number
    @source_branch = source_branch
    @target_branch = target_branch
    @title         = title
    @updated_at    = updated_at
  end
end
