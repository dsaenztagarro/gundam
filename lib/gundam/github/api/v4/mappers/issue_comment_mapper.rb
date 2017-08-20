module Gundam
  module Github
    module API
      module V4
        class CommentMapper
          # @param resource [Hash]
          def self.map(resource)
            IssueComment.new(
              id:         resource['id'],
              body:       resource['body'],
              created_at: Time.parse(resource['publishedAt']),
              updated_at: Time.parse(resource['publishedAt']),
              author:     resource['author']['login'])
          end
        end
      end
    end
  end
end
