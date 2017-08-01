module Gundam
  class CommentDecorator < Decorator
    def string
      <<~END
      #{cyan(author)} #{blue(updated_at)} #{id}
      #{body}
      END
    end

    def string_on_create
      green(html_url)
    end
  end
end
