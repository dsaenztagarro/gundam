# frozen_string_literal: true

require 'yaml'
require 'net/http'

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
  end
end
