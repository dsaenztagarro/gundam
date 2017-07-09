require_relative 'decorator'
require_relative 'helpers/issue_helper'

module Gundam
  class PullRequestDecorator < Decorator
    include Gundam::IssueHelper

    def show_pull(options = {})
      io = StringIO.new
      add_description(io) if options[:with_description]
      add_comments(io) if options[:with_comments]
      add_statuses(io) if options[:with_statuses]
      io.string
    end

    def show_pull_created
      green(html_url)
    end

    private

    # @param output [StringIO]
    def add_statuses(output)
      statuses.each { |status| output.puts CommitStatusDecorator.new(status) }
    end
  end
end
