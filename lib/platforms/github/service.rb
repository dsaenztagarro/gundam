module Platforms
  module Github
    class Service
      def initialize(connector)
        @connector = connector
      end

      # @param repo [String]
      # @param number [Fixnum]
      # @param comment [String]
      # @return [Comment]
      def add_comment(repo, number, comment)
        @connector.add_comment(repo, number, comment)
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

      # @param repo [String]
      # @param number [Fixnum]
      # @return [PullRequest]
      def pull_request(repo, number)
        pull_request = @connector.pull_request(repo, number)
        PullRequest.new(pull_request.to_h)
      end

      # @param repo [String]
      # @param [Hash] options The options to filter pull requests
      # @option options [String] :status The status of the pull request
      # @option options [String] :head
      # @return [PullRequest]
      def pull_requests(repo, options = {})
        pull_requests = @connector.pull_requests(repo, options)
        pull_requests.map do |pull_request|
          PullRequest.new(pull_request.to_h)
        end
      end

      # @param repo [String] The repository name
      # @return [PlatformRepository]
      def repository(repo)
        gateway = @connector.repository(repo)
        PlatformRepository.new(gateway.to_h)
      end

      # @param repo [String]
      # @param sha [String]
      # @return [Array<CommitStatus>]
      def statuses(repo, sha)
        gateways = @connector.statuses(repo, sha)
        gateways.map do |gateway|
          CommitStatus.new(gateway.to_h)
        end
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
