module Platforms
  Unauthorized = Class.new(StandardError)
  CreatePullRequestError = Class.new(StandardError)
  PullRequestNotFound = Class.new(StandardError)
end
