module Platforms
  module Github
    module API
      module V3
        module Gateways
          class CommitStatusGateway < Platforms::Github::API::V3::Gateways::Base
            def to_h
              {
                context:     resource[:context],
                created_at:  resource[:created_at],
                description: resource[:description],
                state:       resource[:state],
                target_url:  resource[:target_url],
                updated_at:  resource[:updated_at],
              }
            end
          end
        end
      end
    end
  end
end
