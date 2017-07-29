module Gundam
  class BaseDirNotFound < StandardError
    def initialize(dir)
      @dir = dir
    end

    def user_message
      "Doesn't exist base dir #{@dir}"
    end
  end
end
