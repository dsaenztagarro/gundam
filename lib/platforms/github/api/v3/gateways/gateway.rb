module Platforms
  module Github
    module API
      module V3
        class Gateway
          attr_reader :resource

          # @param resource [Sawyer::Resource]
          def initialize(resource)
            @resource = resource
          end
        end
      end
    end
  end
end
