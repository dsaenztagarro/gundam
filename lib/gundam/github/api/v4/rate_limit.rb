module Gundam
  module Github
    module API
      module V4
        class RateLimit
          attr_reader :limit, :cost, :remaining, :reset_at

          def initialize(options = {})
            @limit = options[:limit]
            @cost = options[:cost]
            @remaining = options[:remaining]
            @reset_at = options[:reset_at]
          end
        end
      end
    end
  end
end
