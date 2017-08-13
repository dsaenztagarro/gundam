module Gundam
  class IssueDecorator < Decorator
    include Gundam::IssueHelper

    def string
      io = StringIO.new
      add_description(io)
      add_comments(io)
      io.string
    end

    def string_on_create
      green("#{html_url}")
    end
    alias :string_on_update :string_on_create
  end
end
