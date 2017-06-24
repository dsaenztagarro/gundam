require_relative 'decorator'
require_relative 'helpers/issue_helper'

module Gundam
  class PullRequestDecorator < Decorator
    include Gundam::IssueHelper

    def show_pull(options = {})
      io = StringIO.new
      io << show_description if options[:with_description]
      io << show_comments if options[:with_comments]
      io << show_statuses if options[:with_statuses]
      io.string
    end

    def show_pull_created
      green(html_url)
    end

    private

    def show_statuses
      io = StringIO.new
      statuses.each { |status| io.puts CommitStatusDecorator.new(status) }
      io.string
    end
  end
end
