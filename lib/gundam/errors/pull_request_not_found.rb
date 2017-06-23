module Gundam
  class PullRequestNotFound < StandardError
    def initialize(repo, number)
      @repo = repo
      @number = number
    end

    def user_message
      ::I18n.t('errors.pull_request_not_found', repo: @repo, number: @number)
    end
  end
end
