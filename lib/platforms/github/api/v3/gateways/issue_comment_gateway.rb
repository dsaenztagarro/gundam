module Platforms
  module Github
    module API
      module V3
        class IssueCommentGateway < Platforms::Github::API::V3::Gateway
          def to_h
            { body: resource[:body],
              created_at: resource[:created_at],
              updated_at: resource[:updated_at],
              user_login: resource[:user][:login] }
          end
        end
      end
    end
  end
end
