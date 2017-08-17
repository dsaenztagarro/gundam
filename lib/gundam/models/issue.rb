module Gundam
  class Issue
    attr_accessor :comments, :repository, :title, :body, :labels, :number, :html_url

    def initialize(options = {})
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
