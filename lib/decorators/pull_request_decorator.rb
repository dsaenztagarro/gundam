require_relative 'decorator'

class PullRequestDecorator < Decorator
  def to_s
    green(html_url)
  end
end
