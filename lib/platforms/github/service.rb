require_relative 'gateways/gateway'

module Platforms
  module Github
    class Service
      def initialize(connection = Platforms::Github::Connection.new)
        @connection = connection
      end

      # @param repo [String]
      # @param number [Fixnum]
      # @return [Issue]
      def issue(repo, number)
        response = @connection.issue(repo, number)
        issue = Platforms::Github::IssueGateway.new(response)
        Issue.new(issue.to_h)
      end

      # @param repo [String]
      # @param number [Fixnum]
      # @return [Array<IssueComment>]
      def issue_comments(*args)
        response_list = @connection.issue_comments(*args)
        response_list.map do |item|
          issue_comments = Platforms::Github::IssueCommentGateway.new(item)
          IssueComment.new(issue_comments.to_h)
        end
      end

      # @param repo [String] The repository name
      # @return [PlatformRepository]
      def repository(repo)
        response = @connection.repository(repo)
        platform_repository = Platforms::Github::RepositoryGateway.new(response)
        PlatformRepository.new(platform_repository.to_h)
      end

      # @param [Hash] opts the options to create a message with
			# @option opts [String] :repo The repository name
			# @option opts [String] :base The target branch
			# @option opts [String] :head The source branch
			# @option opts [String] :title The title of the pull request
			# @option opts [String] :body The body of the pull request
      # @return [PullRequest]
      def create_pull_request(repo:, base:, head:, title:, body:)
        response = @connection.create_pull_request(repo, base, head, title, body)
        pull_request = Platforms::Github::PullRequestGateway.new(response)
        PullRequest.new(pull_request.to_h)
      end
    end
  end
end
