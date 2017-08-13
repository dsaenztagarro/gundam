module Gundam
  module Github
    module API
      module V3
        class LabelMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::Label.new(
              id:    resource[:id],
              color: resource[:id],
              name:  resource[:name]
            )
          end
        end
      end
    end
  end
end
