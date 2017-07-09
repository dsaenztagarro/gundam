module Gundam
  class LocalRepoNotFound < StandardError
    def initialize(base_dir)
      @base_dir = base_dir
    end

    def user_message
      ::I18n.t('errors.local_repo_not_found', repo: @repo, number: @number)
    end
  end
end
