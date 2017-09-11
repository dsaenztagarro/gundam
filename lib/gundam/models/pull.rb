# frozen_string_literal: true

module Gundam
  class Pull
    attr_accessor :body, :comments, :created_at, :created_by, :head_repo_full_name,
                  :head_sha, :html_url, :number, :repository, :source_branch,
                  :combined_status, :target_branch, :title, :updated_at

    def initialize(options = {})
      self.class.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key])
      end
    end

    class << self
      def keys
        @keys ||= %i[
          body
          comments
          created_at
          created_by
          head_repo_full_name
          head_sha
          html_url
          number
          repository
          source_branch
          combined_status
          target_branch
          title
          updated_at
        ]
      end
    end
  end
end
