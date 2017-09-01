module Gundam
  class PullNotFound < StandardError
    def initialize(repo, number)
      @repo = repo
      @number = number
    end

    def user_message
      "Not found PR ##{@number} on #{@repo}"
    end
  end
end
