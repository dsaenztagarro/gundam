# frozen_string_literal: true

module Gundam
  class PullDecorator < Decorator
    extend Forwardable
    include TextHelper

    def_delegators 'Gundam.theme', :as_title, :as_user, :as_date, :as_id, :as_uri, :as_content, :as_success, :as_error

    STDOUT_TEMPLATE = <<~TEMPLATE
      <%= as_title title %>\n
      <%= as_content body %>\n
      <% comments.each do |comment| -%>
      <%= as_user comment.author %> <%= as_date comment.updated_at %> <%= as_id comment.id %>\n
      <%= as_content comment.body %>\n
      <% end -%>
      <% combined_status.statuses.to_a.each do |status| %>
      <%= status.state.eql?('success') ? as_success(status.state) : as_error(status.state) %> <%= status.context %> <%= status.description %> <%= as_date status.updated_at %>\n
      <% end %>
    TEMPLATE

    def to_stdout
      renderer = ERB.new(STDOUT_TEMPLATE, 0, '>')
      renderer.result(binding)
    end

    # @param doc [Document]
    def update_attributes_from(doc)
      self.title  = doc.data['title']
      self.body   = doc.content
    end

    def string_on_create
      as_uri html_url
    end
    alias string_on_update string_on_create
  end
end
