# frozen_string_literal: true

module Gundam
  class PullDecorator < Decorator
    include TextHelper
    include IssueHelper

    # @param doc [Document]
    def update_attributes_from(doc)
      self.title  = doc.data['title']
      self.body   = doc.content
    end

    def string
      io = StringIO.new
      add_description(io)
      add_comments(io)
      add_statuses(io)
      io.string
    end

    def string_on_create
      green(html_url)
    end
    alias string_on_update string_on_create

    private

    # @param output [StringIO]
    def add_statuses(output)
      return unless combined_status
      combined_status.statuses.to_a.each do |status|
        output.puts CommitStatusDecorator.new(status)
      end
    end
  end
end
