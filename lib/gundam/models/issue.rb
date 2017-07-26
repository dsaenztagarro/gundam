module Gundam
  class Issue
    attr_reader :title, :body, :number

    attr_accessor :comments, :repository

    def initialize(title: nil, body: nil, repository: nil, number: nil, comments: nil)
      @body = body
      @comments = comments || []
      @number = number
      @repository = repository
      @title = title
    end
  end
end
