require_relative '../helpers/colorize_helper'

class IssueDecorator < SimpleDelegator
  include ColorizeHelper

  def to_s
    <<~END
    #{red(title)}
    #{body}
    END
  end
end
