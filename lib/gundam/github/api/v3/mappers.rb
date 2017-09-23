# frozen_string_literal: true

module Gundam
  module Github
    module API
      module V3
        class RemoteRepositoryMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::RemoteRepository.new(
              default_branch: resource['default_branch'],
              full_name: resource['full_name'],
              name: resource['name'],
              owner: resource['owner']['login']
            )
          end
        end

        class IssueMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            assignee = (resource['assignee'] || {})['login']
            assignees = assignee ? [assignee] : []

            Issue.new(
              html_url: resource['html_url'],
              assignees: assignees,
              body:     resource['body'],
              labels:   resource['labels'].map { |lab| LabelMapper.load(lab) },
              number:   resource['number'],
              title:    resource['title']
            )
          end
        end

        class CommentMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Comment.new(
              body:       resource['body'],
              created_at: resource['created_at'],
              html_url:   resource['html_url'],
              id:         resource['id'],
              updated_at: resource['updated_at'],
              author:     resource['user']['login']
            )
          end
        end

        class LabelMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::Label.new(
              id:    resource['id'],
              color: resource['id'],
              name:  resource['name']
            )
          end
        end

        class PullRequestMapper
          # @param resource [Hash]
          def self.load(resource)
            Gundam::Pull.new(
              body:                resource['body'],
              created_at:          resource['created_at'],
              created_by:          resource['user']['login'],
              head_sha:            resource['head']['sha'],
              head_repo_full_name: resource['head']['repo']['full_name'],
              html_url:            resource['_links']['html']['href'],
              number:              resource['number'],
              repository:          resource['base']['repo']['full_name'],
              source_branch:       resource['head']['ref'],
              target_branch:       resource['base']['ref'],
              title:               resource['title'],
              updated_at:          resource['updated_at']
            )
          end
        end

        class CombinedStatusRefMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            statuses = resource['statuses'].map do |status|
              CommitStatusMapper.load(status)
            end

            CombinedStatusRef.new(
              state: resource['state'],
              statuses: statuses
            )
          end
        end

        class CommitStatusMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::CommitStatus.new(
              context:     resource['context'],
              created_at:  resource['created_at'],
              description: resource['description'],
              state:       resource['state'],
              target_url:  resource['target_url'],
              updated_at:  resource['updated_at']
            )
          end
        end

        # TODO: migrate to graphql api

        class TeamMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::Team.new(
              id:  resource['id'],
              name: resource['name']
            )
          end
        end

        class TeamMemberMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::TeamMember.new(
              id:  resource['id'],
              login: resource['login']
            )
          end
        end
      end
    end
  end
end
