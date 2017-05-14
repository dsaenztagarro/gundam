module Platforms
  module Github
    class IssueGateway < Platforms::Github::Gateway
      def to_h
        { title: resource[:title] }
      end
    end
  end
end
