require 'octokit'
require_relative 'gateways/gateway'

module Platforms
  module Github
    module API
      module V3
        # Rest API V3 Connector
        class Connector
          def initialize(client = Connector.new_client)
            @client = client
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @return [IssueGateway]
          def issue(repo, number)
            response = @client.issue(repo, number)
            Platforms::Github::API::V3::IssueGateway.new(response)
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @return [IssueCommentGateway]
          def issue_comments(repo, number)
            response_list = @client.issue_comments(repo, number)
            response_list.map do |item|
              Platforms::Github::API::V3::IssueCommentGateway.new(item)
            end
          end

          # @param repo [String]
          # @return [RepositoryGateway]
          def repository(repo)
            response = @client.repository(repo)
            Platforms::Github::API::V3::RepositoryGateway.new(response)
          rescue Octokit::Unauthorized
            raise Platforms::Unauthorized
          end

          # @param repo [String] A GitHub repository
          # @param base [String] The branch (or git ref) you want your changes pulled into
          # @param head [String] The branch (or git ref) where your changes are implemented
          # @param title [String] Title for the pull request
          # @param body [String] The body for the pull request
          # @return [Saywer::Resource]
          def create_pull_request(repo, base, head, title, body)
            response = @client.create_pull_request(repo, base, head, title, body)
            Platforms::Github::API::V3::PullRequestGateway.new(response)
          rescue Octokit::Error
            raise Platforms::CreatePullRequestError
          end

          def self.new_client
            Octokit::Client.new login: Gundam.github_access_token,
                                password: 'x-oauth-basic'
          end
        end
      end
    end
  end
end
