module Gundam
  module Github
    module API
      module V4
        class IssueCommentMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::IssueComment.new(
              body:       resource['bodyText'],
              created_at: resource['publishedAt'],
              updated_at: resource['publishedAt'],
              author:     resource['author']['login'])
          end

          # @param resource [Sawyer::Resource]
          def self.wrap(resource)
            comments = resource['data']['repositoryOwner']['repository']['issue']['comments']['nodes']
            comments.map { |comment| IssueCommentMapper.load(comment) }
          end
        end
      end
    end
  end
end
