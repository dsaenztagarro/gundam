require_relative 'api/v3/connector'
require_relative 'api/v4/connector'

module Gundam
  module Github
    class Gateway
      extend Forwardable

      def_delegators :@rest_connector,
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

      def_delegators :@graphql_connector, :issue, :pulls

      def initialize(rest_connector: nil, graphql_connector: nil)
        @rest_connector    = rest_connector    || API::V3::Connector.new
        @graphql_connector = graphql_connector || API::V4::Connector.new
      end
    end
  end
end
