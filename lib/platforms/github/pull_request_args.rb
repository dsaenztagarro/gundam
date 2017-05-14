module Vendors
  module Github
    class PullRequestArgs
      attr_reader :repo, :base, :head, :title, :body

      def initialize(repo:, base:, head:, title:, body:)
        @repo = repo
        @base = base
        @head = head
        @title = title
        @body = body
      end
    end
  end
end
