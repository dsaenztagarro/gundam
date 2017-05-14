module Platforms
  module Github
    class PullRequestGateway < Platforms::Github::Gateway
      def to_h
        { title: resource[:title],
          body: resource[:body],
          source_branch: resource[:head][:ref],
          target_branch: resource[:base][:ref],
          html_url: resource[:_links][:html][:href] }
      end
    end
  end
end
