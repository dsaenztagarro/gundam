# frozen_string_literal: true

module Gundam
  module Github
    module API
      module V4
        class RateLimitQuery < Query
          def query
            <<~GRAPHQL
              query {
                viewer {
                  login
                }
                rateLimit {
                  limit
                  cost
                  remaining
                  resetAt
                }
              }
            GRAPHQL
          end
        end
      end
    end
  end
end
