module Gundam
  class PullRequest
    attr_accessor :body, :comments, :created_at, :created_by, :head_repo_full_name,
                :head_sha, :html_url, :number, :repository, :source_branch,
                :statuses, :target_branch, :title, :updated_at

    attr_accessor :comments, :statuses

    def initialize(options = {})
      self.class.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key])
      end
    end

    class << self
      def keys
        @keys ||= [
          :body,
          :comments,
          :created_at,
          :created_by,
          :head_repo_full_name,
          :head_sha,
          :html_url,
          :number,
          :repository,
          :source_branch,
          :statuses,
          :target_branch,
          :title,
          :updated_at
        ]
      end
    end
  end
end
