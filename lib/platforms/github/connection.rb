require 'octokit'
require 'yaml'

module Platforms
  module Github
    class Connection
      def initialize(connection: ConnectionFactory.new_connection)
        @connection = connection
      end

      def issue(*args)
        @connection.issue(*args)
      end

      def issue_comments(*args)
        @connection.issue_comments(*args)
      end

      def repository(*args)
        @connection.repository(*args)
      end

      def create_pull_request(*args)
        @connection.create_pull_request(*args)
      rescue Octokit::Error => error
        raise Platforms::CreatePullRequestError
      end
    end
  end
end
