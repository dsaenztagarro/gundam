module Platforms
  module Github
    class RepositoryGateway < Platforms::Github::Gateway
      def to_h
        { name: resource[:full_name],
          default_branch: resource[:default_branch] }
      end
    end
  end
end
