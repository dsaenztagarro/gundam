module Platforms
  module Github
    module API
      module V3
        module Gateways
          class Base
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
end
