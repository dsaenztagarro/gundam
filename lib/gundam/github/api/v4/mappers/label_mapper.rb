module Gundam
  module Github
    module API
      module V4
        class LabelMapper
          # @param resource [Hash]
          def self.map(resource)
            Label.new(
              id:    resource['id'],
              color: resource['color'],
              name:  resource['name']
            )
          end
        end
      end
    end
  end
end
