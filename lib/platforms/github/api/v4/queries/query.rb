module Platforms
  module Github
    module API
      module V4
        class Query
          def to_s
            query.tr("\n", ' ').squeeze(' ')
          end
        end
      end
    end
  end
end
