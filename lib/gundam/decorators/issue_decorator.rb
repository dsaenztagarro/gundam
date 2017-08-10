module Gundam
  class IssueDecorator < Decorator
    include Gundam::IssueHelper

    def show_cli
      io = StringIO.new
      add_description(io)
      add_comments(io)
      io.string
    end

    def string_on_update
      green("#{html_url} (updated)")
    end
  end
end
