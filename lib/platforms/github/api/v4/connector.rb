require 'json'

module Platforms
  module Github
    module API
      module V4
        # GraphQL API V4 Connector
        class Connector
          # @param repo [String]
          # @param number [Fixnum]
          # @return [IssueCommentGateway]
          def issue_comments(repo, number)
            login, name = repo.split('/')
            response = run_query IssueCommentsQuery.new(login, name, number).to_s
            IssueCommentGateway.wrap(response)
          end

          private

          def run_query(query)
            response = Net::HTTP.post URI('https://api.github.com/graphql'),
              { query: query }.to_json,
              'Authorization' => "bearer #{Gundam.github_access_token}",
              'Content-type'  => 'application/json',
              'User-Agent'    => 'Gundam GraphQL Connector'

            case response
            when Net::HTTPOK then JSON.parse(response.body)
            when Net::HTTPUnauthorized then raise Platforms::UnauthorizedError, response.body
            end
          end
        end
      end
    end
  end
end
