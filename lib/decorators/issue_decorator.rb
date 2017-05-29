require_relative 'decorator'

class IssueDecorator < Decorator
  def to_s
    <<~END
    #{red(title)}
    #{body}
    END
  end
end
