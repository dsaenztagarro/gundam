class Issue
  attr_reader :title, :body

  attr_accessor :comments

  def initialize(title: nil, body: nil)
    @title = title
    @body = body
    @comments = []
  end
end
