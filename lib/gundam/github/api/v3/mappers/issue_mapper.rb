module Gundam
  module Github
    module API
      module V3
        class IssueMapper

          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::Issue.new(
              title: resource[:title],
              body:  resource[:body]
            )
          end
        end
      end
    end
  end
end
