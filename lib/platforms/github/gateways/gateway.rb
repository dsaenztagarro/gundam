module Platforms
  module Github
    class Gateway
      attr_reader :resource

      # @param resource [Sawyer::Resource]
      def initialize(resource)
        @resource = resource
      end
    end
  end
end
