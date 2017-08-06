module Gundam
  class PullRequestDecorator < Decorator
    include Gundam::IssueHelper

    def show_pull
      io = StringIO.new
      add_description(io)
      add_comments(io)
      add_statuses(io)
      io.string
    end

    def show_pull_created
      green(html_url)
    end

    def string_on_update
      green("#{html_url} (updated)")
    end

    private

    # @param output [StringIO]
    def add_statuses(output)
      statuses.to_a.each do |status|
        output.puts CommitStatusDecorator.new(status)
      end
    end
  end
end
