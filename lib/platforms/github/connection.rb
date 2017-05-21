module Platforms
  module Github
    class Connection
      def initialize(connection: ConnectionFactory.new_connection)
        @connection = connection
      end

      # @param repo [String]
      # @param number [Fixnum]
      # @return [Sawyer::Resource] the server response
      def issue(repo, number)
        @connection.issue(repo, number)
      end

      # @param repo [String]
      # @param number [Fixnum]
      # @return [Saywer::Resource] the server response
      def issue_comments(repo, number)
        @connection.issue_comments(repo, number)
      end

      # @param repo [String]
      # @return [Saywer::Resource]
      def repository(repo)
        @connection.repository(repo)
      end

			# @param repo [String] A GitHub repository
			# @param base [String] The branch (or git ref) you want your changes pulled into
			# @param head [String] The branch (or git ref) where your changes are implemented
			# @param title [String] Title for the pull request
			# @param body [String] The body for the pull request
      # @return [Saywer::Resource]
      def create_pull_request(repo, base, head, title, body)
        @connection.create_pull_request(repo, base, head, title, body)
      rescue Octokit::Error => error
        raise Platforms::CreatePullRequestError
      end
    end
  end
end
