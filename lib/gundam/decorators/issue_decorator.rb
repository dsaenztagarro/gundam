# frozen_string_literal: true

module Gundam
  class IssueDecorator < Decorator
    extend Forwardable
    include TextHelper

    def_delegators 'Gundam.theme', :as_title, :as_user, :as_date, :as_id, :as_uri, :as_content

    STDOUT_TEMPLATE = <<~TEMPLATE
      <%= as_title title %>\n
      <%= as_content body %>\n
      <% comments.each do |comment| %>
      <%= as_user comment.author %> <%= as_date comment.updated_at %> <%= as_id comment.id %>\n
      <%= as_content comment.body %>\n
      <% end %>
    TEMPLATE

    def to_stdout
      renderer = ERB.new(STDOUT_TEMPLATE, 0, '>')
      renderer.result(binding)
    end

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

    def string_on_create
      as_uri html_url.to_s
    end
    alias string_on_update string_on_create
  end
end
