# frozen_string_literal: true

module Gundam
  class Comment
    attr_accessor :body, :created_at, :html_url, :id, :updated_at, :author

    def initialize(options = {})
      self.class.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key])
      end
    end

    class << self
      def keys
        @keys ||= %i[
          body
          created_at
          html_url
          id
          updated_at
          author
        ]
      end
    end
  end
end
