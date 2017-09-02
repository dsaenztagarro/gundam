# frozen_string_literal: true

module Gundam
  class LocalRepoNotFound < StandardError
    def initialize(base_dir)
      @base_dir = base_dir
    end

    def user_message
      "Not found local repo at #{@base_dir}"
    end
  end
end
