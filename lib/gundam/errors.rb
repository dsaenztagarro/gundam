module Gundam
  CreatePullRequestError = Class.new(StandardError)

  # Raised when Gateway returns a 422 HTTP status code
  UnprocessableEntity = Class.new(StandardError)
end

