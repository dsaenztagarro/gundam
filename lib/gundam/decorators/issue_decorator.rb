# frozen_string_literal: true

module Gundam
  class IssueDecorator < Decorator
    include TextHelper
    include IssueHelper

    # @param doc [Document]
    # @return [Gundam::Issue]
    def update_attributes_from(doc)
      tap do |issue|
        issue.assignees = doc.data['assignees'].to_s.split(',').map(&:strip)
        issue.body      = doc.content
        issue.title     = doc.data['title']
        issue.labels    = doc.data['labels'].to_s.split(',').map do |label|
          Label.new(name: label.strip)
        end
      end
    end

    def string
      io = StringIO.new
      add_description(io)
      io.puts
      add_comments(io)
      io.string
    end

    def string_on_create
      green(html_url.to_s)
    end
    alias string_on_update string_on_create
  end
end
