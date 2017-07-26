require 'json'
require_relative 'query_cache'

module Gundam
  module Github
    module API
      module V4
        # GraphQL API V4 Gateway
        class Gateway
          def initialize
            @cache = QueryCache.new
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @return [Gundam::IssueComment]
          def issue(repo, number)
            response = run_issue_query(repo, number)
            IssueMapper.load(response)
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @return [Gundam::IssueComment]
          def issue_comments(repo, number)
            response = run_issue_query(repo, number)
            IssueCommentMapper.wrap(response)
          end

          private

          attr_reader :cache

          def run_issue_query(repo, number)
            login, name = repo.split('/')
            run_query_with_cache IssueQuery.new(login, name, number)
          end

          def run_query_with_cache(query)
            if cache.include?(query)
              cache.get(query)
            else
              run_query(query).tap { |response| cache.add(query, response) }
            end
          end

          def run_query(query)
            response = Net::HTTP.post URI('https://api.github.com/graphql'),
                                      { query: query.to_s }.to_json,
                                      'Authorization' => "bearer #{Gundam.github_access_token}",
                                      'Content-type'  => 'application/json',
                                      'User-Agent'    => 'Gundam GraphQL Gateway'

            case response
            when Net::HTTPOK then JSON.parse(response.body)
            when Net::HTTPUnauthorized then raise Platforms::Unauthorized, response.body
            end
          end
        end
      end
    end
  end
end
