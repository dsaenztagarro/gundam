module Gundam
  class IssueNotFound < StandardError
    def initialize(repo, number)
      @repo = repo
      @number = number
    end

    def user_message
      ::I18n.t('errors.issue_not_found', repo: @repo, number: @number)
    end
  end
end
