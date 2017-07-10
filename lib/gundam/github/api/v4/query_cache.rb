module Gundam
  module Github
    module API
      module V4
        class QueryCache
          def initialize
            @cache = {}
          end

          def include?(query)
            @cache.include?(query.key)
          end

          def add(query, response)
            @cache[query.key] = response
          end

          def get(query)
            @cache[query.key]
          end
        end
      end
    end
  end
end
