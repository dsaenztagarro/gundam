module Platforms
  module Github
    module API
      module V3
        class RepositoryGateway < Platforms::Github::API::V3::Gateway
          def to_h
            { name: resource[:full_name],
              default_branch: resource[:default_branch] }
          end
        end
      end
    end
  end
end
