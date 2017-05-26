require_relative '../helpers/colorize_helper'

class IssueCommentDecorator < SimpleDelegator
  include ColorizeHelper

  def to_s
    <<~END
    #{cyan(user_login)} #{blue(updated_at)}
    #{body}
    END
  end
end
