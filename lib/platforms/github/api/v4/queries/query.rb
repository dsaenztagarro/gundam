module Platforms
  module Github
    module API
      module V4
        class Query
          def to_s
            query.gsub("\n", ' ').squeeze(' ')
          end
        end
      end
    end
  end
end
