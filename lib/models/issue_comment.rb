class IssueComment
  attr_reader :body, :user_login, :created_at, :updated_at

  def initialize(body:, user_login:, created_at:, updated_at:)
    @body = body
    @user_login = user_login
    @created_at = created_at
    @updated_at = updated_at
  end
end
