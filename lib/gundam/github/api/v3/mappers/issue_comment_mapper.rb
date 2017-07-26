module Gundam
  module Github
    module API
      module V3
        class IssueCommentMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::IssueComment.new(
              body:       resource[:body],
              created_at: resource[:created_at],
              html_url:   resource[:html_url],
              id:         resource[:id],
              updated_at: resource[:updated_at],
              author:     resource[:user][:login]
            )
          end
        end
      end
    end
  end
end
