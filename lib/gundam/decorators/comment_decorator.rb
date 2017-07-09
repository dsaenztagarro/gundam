require_relative 'decorator'

module Gundam
  class CommentDecorator < Decorator
    def string
      <<~END
      #{cyan(user_login)} #{blue(updated_at)}
      #{body}
      END
    end

    def string_on_create
      green(html_url)
    end
  end
end
