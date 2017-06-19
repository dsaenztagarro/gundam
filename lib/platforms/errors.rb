module Platforms
  CreatePullRequestError = Class.new(StandardError)
  IssueNotFound = Class.new(StandardError)
  PullRequestNotFound = Class.new(StandardError)
  Unauthorized = Class.new(StandardError)
end
