module Platforms
  module Github
    module API
      module V3
        module Gateways
          class IssueGateway < Platforms::Github::API::V3::Gateways::Base
            def to_h
              { title: resource[:title],
                body: resource[:body] }
            end
          end
        end
      end
    end
  end
end
