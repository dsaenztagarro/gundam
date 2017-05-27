module Platforms
  module Github
    module API
      module V4
        class IssueCommentGateway < Platforms::Github::API::V4::Gateway
          def to_h
            { body: response['bodyText'],
              created_at: response['publishedAt'],
              updated_at: response['publishedAt'],
              user_login: response['author']['login'] }
          end

          def self.wrap(response)
            comments = response["data"]["repositoryOwner"]["repository"]["issue"]["comments"]["nodes"]
            comments.map do |comment|
              IssueCommentGateway.new(comment)
            end
          end
        end
      end
    end
  end
end
