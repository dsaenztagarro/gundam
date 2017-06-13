module Platforms
  module Github
    module API
      module V4
        class IssueGateway < Platforms::Github::API::V4::Gateway
          def to_h
            issue = response["data"]["repositoryOwner"]["repository"]["issue"]
            { body: issue['bodyText'],
              title: issue['title'] }
          end
        end
      end
    end
  end
end
