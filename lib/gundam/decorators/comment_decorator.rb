# frozen_string_literal: true

module Gundam
  class CommentDecorator < Decorator
    extend Forwardable

    def_delegators 'Gundam.theme', :as_uri

    def string_on_create
      as_uri html_url
    end
  end
end
