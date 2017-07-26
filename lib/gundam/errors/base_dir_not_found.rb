module Gundam
  class BaseDirNotFound < StandardError
    def initialize(dir)
      @dir = dir
    end

    def user_message
      ::I18n.t('errors.base_dir_not_found', dir: @dir)
    end
  end
end
