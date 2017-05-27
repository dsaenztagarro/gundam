module Platforms
  module Github
    module API
      module V3
        class IssueGateway < Platforms::Github::API::V3::Gateway
          def to_h
            { title: resource[:title],
              body: resource[:body] }
          end
        end
      end
    end
  end
end
