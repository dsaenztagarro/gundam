require_relative 'decorator'

class IssueCommentDecorator < Decorator
  def to_s
    <<~END
    #{cyan(user_login)} #{blue(updated_at)}
    #{body}
    END
  end
end
