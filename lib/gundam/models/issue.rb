module Gundam
  class Issue
    attr_reader :title, :body, :number, :html_url

    attr_accessor :comments, :repository

    def initialize(options = {})
      @body       = options[:body]
			@html_url   = options[:html_url]
      @comments   = options.fetch(:comments, [])
      @number     = options[:number]
      @repository = options[:repository]
      @title      = options[:title]
    end
  end
end
