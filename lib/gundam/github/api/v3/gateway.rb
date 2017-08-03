require 'octokit'

module Gundam
  module Github
    module API
      module V3
        # Rest API V3 Gateway
        class Gateway
          def initialize(client = Gateway.new_client)
            @client = client
          end

          def issue_comment(repo, number)
            response = @client.issue_comment(repo, number)
            IssueCommentMapper.load(response)
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @param comment [String]
          # @return [Gundam::IssueComment]
          def add_comment(repo, number, comment)
            response = @client.add_comment(repo, number, comment)
            IssueCommentMapper.load(response)
          end

          # @param repo [String] A GitHub repository
          # @param number [Fixnum] Comment number
          # @param comment [String] Body of the comment which will replace the existing body
          # @return [Gundam::IssueComment]
          def update_comment(repo, number, comment)
            response = @client.update_comment(repo, number, comment)
            IssueCommentMapper.load(response)
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @return [Gundam::Issue]
          def issue(repo, number)
            response = @client.issue(repo, number)
            IssueMapper.load(response)
          rescue Octokit::NotFound
            raise Gundam::IssueNotFound.new(repo, number)
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @return [IssueCommentGateway]
          def issue_comments(repo, number)
            list = @client.issue_comments(repo, number)
            list.map { |item| IssueCommentMapper.load(item) }
          end


          # @param repo [String]
          # @param number [Fixnum]
          # @return [PullRequestGateway]
          def pull_request(repo, number)
            response = @client.pull_request(repo, number)
            PullRequestMapper.load(response)
          rescue Octokit::NotFound
            raise Gundam::PullRequestNotFound.new(repo, number)
          end

          # @param repo [String]
          # @param number [Fixnum]
          # @return [Gundam::PullRequest]
          def pull_requests(repo, options = {})
            list = @client.pull_requests(repo, options)
            list.map { |pull_request| PullRequestMapper.load(pull_request) }
          end

          # @param repo [String]
          # @return [RepositoryGateway]
          def repository(repo)
            response = @client.repository(repo)
            RemoteRepositoryMapper.load(response)
          rescue Octokit::Unauthorized
            raise Gundam::Unauthorized.new(:github_api_v3)
          end

          # @param repo [String]
          # @param sha [String]
          # @return [CommitStatus]
          def statuses(repo, sha)
            response = @client.statuses(repo, sha)
            response.map { |status| CommitStatusMapper.load(status) }
          end

          # @param repo [String] A GitHub repository
          # @param base [String] The branch (or git ref) you want your changes pulled into
          # @param head [String] The branch (or git ref) where your changes are implemented
          # @param title [String] Title for the pull request
          # @param body [String] The body for the pull request
          # @return [Saywer::Resource]
          def create_pull_request(repo:, base:, head:, title:, body:)
            response = @client.create_pull_request(repo, base, head, title, body)
            PullRequestMapper.load(response)
          rescue Octokit::Error
            raise Gundam::CreatePullRequestError
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
