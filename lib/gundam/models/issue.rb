# frozen_string_literal: true

module Gundam
  class Issue
    attr_accessor :assignees, :comments, :repository, :title, :body, :labels, :number, :html_url

    def initialize(options = {})
      @assignees  = options.fetch(:assignees, [])
      @body       = options[:body]
      @labels     = options.fetch(:labels, [])
      @html_url   = options[:html_url]
      @comments   = options.fetch(:comments, [])
      @number     = options[:number]
      @repository = options[:repository]
      @title      = options[:title]
    end
  end
end
