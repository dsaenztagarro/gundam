class PullRequest
  attr_reader :title,
              :body,
              :html_url,
              :source_branch,
              :target_branch

  def initialize(title:, body:, html_url:, source_branch:, target_branch:)
    @title         = title
    @body          = body
    @html_url      = html_url
    @source_branch = source_branch
    @target_branch = target_branch
  end
end
