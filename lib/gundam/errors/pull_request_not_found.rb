module Gundam
  class PullRequestNotFound < StandardError
    def initialize(repo, number)
      @repo = repo
      @number = number
    end

    def user_message
      "Not found PR ##{@number} on #{@repo}"
    end
  end
end
