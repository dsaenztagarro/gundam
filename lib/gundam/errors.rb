# frozen_string_literal: true

module Gundam
  IssueNotFound = Class.new(StandardError)
  CreatePullRequestError = Class.new(StandardError)

  # Raised when Gateway returns a 422 HTTP status code
  UnprocessableEntity = Class.new(StandardError)
end
