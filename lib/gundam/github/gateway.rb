# frozen_string_literal: true

module Gundam
  module Github
    class Gateway
      extend Forwardable

      def_delegators :rest_connector,
                     :org_teams,
                     :team_members,
                     :issue_comment,
                     :add_comment,
                     :update_comment,
                     :create_issue,
                     :update_issue,
                     :issue_comments,
                     :repository,
                     :update_pull_request,
                     :combined_status,
                     :create_pull_request

      def_delegators :graphql_connector, :issue, :pulls

      def rest_connector
        @rest_connector ||= begin
                              require_relative 'api/v3/connector'
                              API::V3::Connector.new
                            end
      end

      def graphql_connector
        @graphql_connector ||= begin
                                 require_relative 'api/v4/connector'
                                 API::V4::Connector.new
                               end
      end
    end
  end
end
