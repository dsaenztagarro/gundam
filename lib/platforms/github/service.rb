module Platforms
  module Github
    class Service
      def initialize(connector)
        @connector = connector
      end

      # @param repo [String]
      # @param number [Fixnum]
      # @return [Issue]
      def issue(repo, number)
        gateway = @connector.issue(repo, number)
        Issue.new(gateway.to_h)
      end

      # @param repo [String]
      # @param number [Fixnum]
      # @return [Array<IssueComment>]
      def issue_comments(repo, number)
        gateways = @connector.issue_comments(repo, number)
        gateways.map do |gateway|
          IssueComment.new(gateway.to_h)
        end
      end

      # @param repo [String] The repository name
      # @return [PlatformRepository]
      def repository(repo)
        gateway = @connector.repository(repo)
        PlatformRepository.new(gateway.to_h)
      end

      # @param [Hash] opts the options to create a message with
			# @option opts [String] :repo The repository name
			# @option opts [String] :base The target branch
			# @option opts [String] :head The source branch
			# @option opts [String] :title The title of the pull request
			# @option opts [String] :body The body of the pull request
      # @return [PullRequest]
      def create_pull_request(repo:, base:, head:, title:, body:)
        gateway = @connector.create_pull_request(repo, base, head, title, body)
        PullRequest.new(gateway.to_h)
      end
    end
  end
end
