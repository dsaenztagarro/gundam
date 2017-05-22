class Issue
  attr_reader :title, :body

  def initialize(title: nil, body: nil)
    @title = title
    @body = body
  end
end
