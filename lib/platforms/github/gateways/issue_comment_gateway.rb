module Platforms
  module Github
    class IssueCommentGateway < Platforms::Github::Gateway
      def to_h
        { body: resource[:body],
          created_at: resource[:created_at],
          updated_at: resource[:updated_at],
          user_login: resource[:user][:login] }
      end
    end
  end
end
