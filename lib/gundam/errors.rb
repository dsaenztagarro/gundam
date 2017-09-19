# frozen_string_literal: true

module Gundam
  Error                  = Class.new(StandardError)
  IssueNotFound          = Class.new(Error)
  CreatePullRequestError = Class.new(Error)

  # Raised when Gateway returns a 422 HTTP status code
  UnprocessableEntity = Class.new(Error)

  class HTTPError < Error
    attr_reader :response

    def initialize(response)
      @response = response
    end
  end
end
