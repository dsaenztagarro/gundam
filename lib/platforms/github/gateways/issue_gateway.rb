module Platforms
  module Github
    class IssueGateway < Platforms::Github::Gateway
      def to_h
        { title: resource[:title],
          body: resource[:body] }
      end
    end
  end
end
