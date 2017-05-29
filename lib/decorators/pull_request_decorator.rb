require_relative 'decorator'

class PullRequestDecorator < Decorator
  def to_s_on_success_created
    green(html_url)
  end

  def to_s
    <<~END
    #{magenta("#{title} ##{number}")}
    #{body}
    END
  end
end
