# frozen_string_literal: true

module Gundam
  class CommentDecorator < Decorator
    include TextHelper

    def string
      <<~OUT
        #{cyan(author)} #{blue(updated_at)} #{id}
        #{reformat_wrapped(body)}
      OUT
    end

    def string_on_create
      green(html_url)
    end
  end
end
