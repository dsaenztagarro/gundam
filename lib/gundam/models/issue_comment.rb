module Gundam
  class IssueComment
    attr_reader :body, :created_at, :html_url, :id, :updated_at, :author

    def initialize(options = {})
      self.class.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key])
      end
    end

    class << self
      def keys
        @keys ||= [
          :body,
          :created_at,
          :html_url,
          :id,
          :updated_at,
          :author
        ]
      end
    end
  end
end
