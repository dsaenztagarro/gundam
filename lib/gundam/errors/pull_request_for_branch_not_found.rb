module Gundam
  class PullRequestForBranchNotFound < StandardError
    def initialize(head)
      @head = head
    end

    def user_message
      "Not found PR for branch #{@head}"
    end
  end
end
