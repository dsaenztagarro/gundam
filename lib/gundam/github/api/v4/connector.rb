# frozen_string_literal: true

require 'json'

require_relative 'rate_limit'
require_relative 'mappers/issue_mapper'
require_relative 'mappers/label_mapper'
require_relative 'mappers/pull_mapper'
require_relative 'mappers/comment_mapper'
require_relative 'mappers/combined_status_ref_mapper'
require_relative 'mappers/rate_limit_mapper'
require_relative 'queries/query'
require_relative 'queries/issue_query'
require_relative 'queries/pulls_query'
require_relative 'queries/rate_limit_query'

module Gundam
  module Github
    module API
      module V4
        # GraphQL API V4 Connector
        class Connector
          GRAPHQL_API_ENDPOINT = 'https://api.github.com/graphql'

          # @param owner [String]
          # @param repo [String]
          # @param number [Fixnum]
          # @param options [Hash] issue search options
          # @option option [Boolean] :with_comments
          # @return [Gundam::Issue]
          def issue(owner, repo, number, options = {})
            response = run_query(IssueQuery.new(owner, repo, number, options))
            IssueMapper.map(response)
          end

          # @param owner [String]
          # @param repo [String]
          # @param head [String]
          # @param options [Hash] pull search options
          # @option option [Boolean] :expanded
          # @return [Array<Gundam::Pull>]
          def pulls(owner, repo, head, options = {})
            response = run_query PullsQuery.new(owner, repo, head, options)
            PullMapper.wrap(response)
          end

          def rate_limit
            response = run_query(RateLimitQuery.new)
            RateLimitMapper.map(response)
          end

          def run_query(query)
            uri    = URI(GRAPHQL_API_ENDPOINT)
            data   = { query: query.to_s }.to_json
            header = {
              'Authorization'   => "bearer #{Gundam.github_access_token}",
              'Content-type'    => 'application/json',
              'Accept-Encoding' => 'gzip',
              'User-Agent'      => 'Gundam GitHub GraphQL Connector'
            }

            response = Net::HTTP.post(uri, data, header)

            case response
            when Net::HTTPOK           then parse_response(response)
            when Net::HTTPUnauthorized then raise_unauthorized(response)
            end
          end

          private

          attr_reader :cache

          # @param response [Net::HTTPOK]
          def parse_response(response)
            JSON.parse(unzipped_body(response))
          end

          # @param response [Net::HTTPOK]
          def unzipped_body(response)
            if response.header['Content-Encoding'].eql?('gzip')
              Zlib::GzipReader.new(StringIO.new(response.body)).read
            else
              response.body
            end
          end

          # @param response [Net::HTTPUnauthorized]
          def raise_unauthorized(response)
            raise Gundam::Error, "Unauthorized access to Github GraphQL API V4\n#{response.body}"
          end
        end
      end
    end
  end
end
