module Gundam
  class PullRequestForBranchNotFound < StandardError
    def initialize(head)
      @head = head
    end

    def user_message
      ::I18n.t('errors.pull_request_for_branch_not_found', head: @head)
    end
  end
end
