module Platforms
  module Github
    module API
      module V4
        class Gateway
          attr_reader :response

          # @param response [Hash]
          def initialize(response)
            @response = response
          end
        end
      end
    end
  end
end
