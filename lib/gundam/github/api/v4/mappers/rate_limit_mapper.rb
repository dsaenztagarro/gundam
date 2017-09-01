module Gundam
  module Github
    module API
      module V4
        class RateLimitMapper
          # @param resource [Hash]
          def self.map(resource)
            rate_limit = resource['data']['rateLimit']

            RateLimit.new(
              limit:     rate_limit['limit'].to_i,
              cost:      rate_limit['cost'].to_i,
              remaining: rate_limit['remaining'].to_i,
              reset_at:  Time.parse(rate_limit['resetAt'])
            )
          end
        end
      end
    end
  end
end
