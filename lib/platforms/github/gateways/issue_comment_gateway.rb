module Platforms
  module Github
    class IssueCommentGateway < Platforms::Github::Gateway
      def to_h
        { body: resource[:body],
          user_login: resource[:user][:login],
          created_at: resource[:created_at],
          updated_at: resource[:updated_at] }
      end
    end
  end
end
