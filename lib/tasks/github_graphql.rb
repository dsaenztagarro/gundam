# frozen_string_literal: true

require 'yaml'
require 'net/http'
require 'pp' # A pretty-printer for Ruby objects

require_relative '../gundam'
require_relative '../gundam/github/api/v4/connector'
require_relative '../gundam/github/api/v4/rate_limit'
require_relative '../gundam/github/api/v4/queries/rate_limit_query'

namespace :github do
  desc 'Setup Gundam GitHub credentials'
  task :setup do
    config = YAML.load_file(File.expand_path('~/.gundam.yml'))

    Gundam.configure do |c|
      c.github_access_token = config['github']['personal_access_token']
    end
  end

  namespace :graphql do
    desc 'Check GitHub GraphQL overall rate limits'
    task rate_limit: ['github:setup']  do
      graphql_connector = Gundam::Github::API::V4::Connector.new

      rate_limit = graphql_connector.rate_limit

      puts "Limit: #{rate_limit.limit}"
      puts "Cost: #{rate_limit.cost}"
      puts "Remaining: #{rate_limit.remaining}"
      puts "Reset At: #{rate_limit.reset_at}"
    end

    # Example
    # rake github:graphql:introspect[Comment]
    desc 'Query a GraphQL schema for details about it'
    task :introspect_schema, [:type] => ['github:setup'] do |_task, _args|
      query = <<~QUERY
        query {
          __schema {
            types {
              name
              kind
              description
              fields {
                name
              }
            }
          }
        }
      QUERY

      graphql_connector = Gundam::Github::API::V4::Connector.new

      pp graphql_connector.run_query(query)
    end

    # Example
    #
    # rake github:graphql:introspect_type[Comment]

    desc 'Query a GraphQL schema for details about it'
    task :introspect_type, [:type] => ['github:setup'] do |_task, args|
      query = <<~QUERY
        query {
          __type(name: "#{args.type}") {
            name
            kind
            description
            fields {
              name
            }
          }
        }
      QUERY

      graphql_connector = Gundam::Github::API::V4::Connector.new

      pp graphql_connector.run_query(query)
    end
  end
end
