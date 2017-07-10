module Gundam
  module Github
    module API
      module V4
        class IssueMapper

          # @param resource [Sawyer::Resource]
          def self.load(resource)
            issue = resource["data"]["repositoryOwner"]["repository"]["issue"]
            Gundam::Issue.new(
              body: issue['bodyText'],
              title: issue['title'])
          end
        end
      end
    end
  end
end
