require 'octokit'
require 'yaml'

module Platforms
  module Github
    class Connection
      def initialize
        @connection = Octokit::Client.new login: github_access_token,
                                          password: 'x-oauth-basic'
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

      private

      def github_access_token
        config['github']['personal_access_token']
      end

      def github_user
        config['github']['user']
      end

      def github_password
        config['github']['password']
      end

      def config
        @config ||= YAML.load_file(File.expand_path '~/.gundam.yml')
      end
    end
  end
end
