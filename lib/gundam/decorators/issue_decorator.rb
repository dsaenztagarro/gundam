module Gundam
  class IssueDecorator < Decorator
    include Gundam::IssueHelper

    # @param doc [Document]
    def update_attributes_from(doc)
      self.title  = doc.data['title']
      self.body   = doc.content
      self.labels = doc.data['labels'].to_s.split(',').map do |label|
        Label.new(name: label.strip)
      end
    end

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
