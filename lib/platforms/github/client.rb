require_relative 'gateways/gateway'

module Platforms
  module Github
    class Client
      def initialize(connection = Platforms::Github::Connection.new)
        @connection = connection
      end

      def process(request)
        issue = @connection.issue(request['repo'], request['issue_number'])
        issue.to_attrs.merge!(labels: issue.labels)
      end

      # @param repo [String]
      # @return [PlatformRepository]
      def repository(repo)
        response = @connection.repository(repo)
        platform_repository = Platforms::Github::RepositoryGateway.new(response)
        PlatformRepository.new(platform_repository.to_h)
      end

      # @param repo [String]
      # @param number [Fixnum]
      # @return [Issue]
      def issue(repo, number)
        response = @connection.issue(repo, number)
        issue = Platforms::Github::IssueGateway.new(response)
        Issue.new(issue.to_h)
      end

      def issue_comments(*args)
        response = @connection.issue_comments(*args)
        issue_comments = Platforms::Github::IssueCommentsGateway.new(response)
        IssueComments.new(issue_comments.to_h)
      end

      # @param args [Platforms::Github::PullRequestArgs]
      # @return [Platforms::Github::Response::CreatePullRequest]
      def create_pull_request(repo:, base:, head:, title:, body:)
        response = @connection.create_pull_request(repo, base, head, title, body)
        pull_request = Platforms::Github::PullRequestGateway.new(response)
        PullRequest.new(pull_request.to_h)
      end
    end
  end
end
