module Gundam
  module Github
    module API
      module V3
        class IssueCommentMapper
          # @param response [Sawyer::Resource]
          def initialize(response)
            @response = response
          end

          def to_h
            {
              body: @response[:body],
              created_at: @response[:created_at],
              html_url: @response[:html_url],
              id: @response[:id],
              updated_at: @response[:updated_at],
              user_login: @response[:user_login]
            }
          end
        end
      end
    end
  end
end
