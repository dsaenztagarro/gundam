require 'octokit'
require_relative 'gateways/base'

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
            Platforms::Github::API::V3::Gateways::IssueGateway.new(response)
          rescue Octokit::NotFound
            raise Gundam::IssueNotFound.new(repo, number)
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @return [IssueCommentGateway]
          def issue_comments(repo, number)
            list = @client.issue_comments(repo, number)
            list.map do |item|
              Platforms::Github::API::V3::Gateways::IssueCommentGateway.new(item)
            end
          end


          # @param repo [String]
          # @param number [Fixnum]
          # @return [PullRequestGateway]
          def pull_request(repo, number)
            pull = @client.pull_request(repo, number)
            Platforms::Github::API::V3::Gateways::PullRequestGateway.new(pull)
          rescue Octokit::NotFound
            raise Gundam::PullRequestNotFound.new(repo, number)
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @return [PullRequestGateway]
          def pull_requests(repo, options = {})
            list = @client.pull_requests(repo, options)
            list.map do |pull_request|
              Platforms::Github::API::V3::Gateways::PullRequestGateway.new(pull_request)
            end
          end

          # @param repo [String]
          # @return [RepositoryGateway]
          def repository(repo)
            response = @client.repository(repo)
            Platforms::Github::API::V3::Gateways::RepositoryGateway.new(response)
          rescue Octokit::Unauthorized
            raise Platforms::Unauthorized
          end

          # @param repo [String]
          # @param sha [String]
          # @return [CommitStatus]
          def statuses(repo, sha)
            list = @client.statuses(repo, sha)
            list.map do |status|
              Platforms::Github::API::V3::Gateways::CommitStatusGateway.new(status.to_h)
            end
          end

          # @param repo [String] A GitHub repository
          # @param base [String] The branch (or git ref) you want your changes pulled into
          # @param head [String] The branch (or git ref) where your changes are implemented
          # @param title [String] Title for the pull request
          # @param body [String] The body for the pull request
          # @return [Saywer::Resource]
          def create_pull_request(repo, base, head, title, body)
            response = @client.create_pull_request(repo, base, head, title, body)
            Platforms::Github::API::V3::Gateways::PullRequestGateway.new(response)
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
