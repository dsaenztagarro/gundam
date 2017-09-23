# frozen_string_literal: true

require_relative '../../../rest_client'
require_relative 'mappers'

module Gundam
  module Github
    module API
      module V3
        # GitHub Rest API V3 Connector
        class Connector
          def initialize(client = Connector.new_client)
            @client = client
          end

          def org_teams(organization)
            response = @client.org_teams(organization)
            response.map { |resource| TeamMapper.load(resource) }
          end

          def team_members(team_id)
            response = @client.team_members(team_id)
            response.map { |resource| TeamMemberMapper.load(resource) }
          end

          # @param repository[String] as "owner/repo"
          # @param id [Fixnum] The id of the comment
          def issue_comment(repository, id)
            path = "/repos/#{repository}/issues/comments/#{id}"
            response = @client.get(path)
            CommentMapper.load(response)
          end

          # @param repository[String] as "owner/repo"
          # @param number [Fixnum] The issue number
          # @param comment [String]
          # @return [Gundam::Comment]
          def add_comment(repository, number, comment)
            path = "/repos/#{repository}/issues/#{number}/comments"
            response = @client.post(path, body: comment)
            CommentMapper.load(response)
          end

          # @param repository[String] A GitHub repository as "owner/repo"
          # @param id [Fixnum] Comment number
          # @param text [String] Body of the comment which will replace the existing body
          # @return [Gundam::Comment]
          def update_comment(repository, id, text)
            path = "/repos/#{repository}/issues/comments/#{id}"
            response = @client.patch(path, body: text)
            CommentMapper.load(response)
          end

          # @param repository[String] A GitHub repository as "owner/repo"
          # @param [Gundam::Issue]
          # @return [Gundam::Issue]
          def create_issue(repository, issue)
            path = "/repos/#{repository}/issues"
            params = {
              title: issue.title,
              body: issue.body,
              assignees: issue.assignees,
              labels: issue.labels.map(&:name)
            }
            response = @client.post(path, params)
            IssueMapper.load(response)
          end

          # @param repository[String] A GitHub repository as "owner/repo"
          # @param [Gundam::Issue]
          # @return [Gundam::Issue]
          def update_issue(repository, issue)
            path = "/repos/#{repository}/issues"
            params = {
              assignee: issue.assignees.first,
              body:     issue.body,
              labels:   issue.labels.map(&:name),
              title:    issue.title
            }
            response = @client.patch(path, params)
            IssueMapper.load(response)
          rescue Octokit::UnprocessableEntity
            raise Gundam::UnprocessableEntity
          end

          # @param repository[String] A GitHub repository as "owner/repo"
          # @return [Gundam::RemoteRepository]
          def repository(repository)
            path = "/repos/#{repository}"
            response = @client.get(path)
            RemoteRepositoryMapper.load(response)
          rescue # Octokit::Unauthorized
            raise Gundam::Unauthorized, :github_api_v3
          end

          # @param repository[String] A GitHub repository as "owner/repo"
          # @param [Gundam::PullRequest]
          # @return [Gundam::PullRequest]
          def update_pull_request(repository, pull)
            path = "/repos/#{repository}/pulls/#{pull.number}"
            params = {
              title: pull.title,
              body: pull.body
            }
            response = @client.patch(path, params)
            PullRequestMapper.load(response)
          end

          # @param repo [String]
          # @param sha [String]
          # @return [CombinedStatusRef]
          def combined_status(repo, sha)
            response = @client.combined_status(repo, sha)
            CombinedStatusRefMapper.load(response)
          end

          # @param repo [String] A GitHub repository
          # @param base [String] The branch (or git ref) you want your changes pulled into
          # @param head [String] The branch (or git ref) where your changes are implemented
          # @param title [String] Title for the pull request
          # @param body [String] The body for the pull request
          # @return [Gundam::PullRequest]
          def create_pull_request(options)
            path = "/repos/#{options[:repo]}/pulls"
            params = options.keep_if do |key, _|
              %w(title body head base).include? key.to_s
            end
            response = @client.post(path, params)
            PullRequestMapper.load(response)
          rescue Gundam::HTTPError => error
            raise_api_error(error)
          end

          def self.new_client
            headers = {
              'Authorization' => "token #{Gundam.github_access_token}",
              'Accept'        => 'application/vnd.github.v3+json'
            }
            RestClient.new endpoint: 'https://api.github.com', headers: headers
          end

          private

          def raise_api_error(error)
            raise HTTPError, error.response
          end
        end

        # GitHub Rest API V3 HTTPError
        class HTTPError < Gundam::HTTPError
          def user_message
            json = JSON.parse(response.body)
            json['errors'].map { |error| error['message'] }.join("\n")
          end
        end
      end
    end
  end
end
