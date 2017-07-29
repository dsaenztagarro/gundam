module Gundam
  class IssueNotFound < StandardError
    def initialize(repo, number)
      @repo = repo
      @number = number
    end

    def user_message
      "Not found issue ##{@number} on #{@repo}"
    end
  end
end
