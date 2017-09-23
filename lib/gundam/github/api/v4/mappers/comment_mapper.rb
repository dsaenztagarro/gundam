# frozen_string_literal: true
require 'time'

module Gundam
  module Github
    module API
      module V4
        class CommentMapper
          # @param resource [Hash]
          def self.map(resource)
            Comment.new(
              id:         resource['databaseId'],
              body:       resource['body'],
              created_at: Time.parse(resource['publishedAt']),
              updated_at: Time.parse(resource['publishedAt']),
              author:     resource['author']['login']
            )
          end
        end
      end
    end
  end
end
