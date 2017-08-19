require_relative '../gundam/github/api/v4/gateway'

require 'byebug'
require 'yaml'
require_relative '../gundam'
require 'net/http'

namespace :github do
  namespace :graphql do
    desc 'Test GitHub GraphQL queries'
    task :test do
      config = YAML.load_file(File.expand_path('~/.gundam.yml'))

      Gundam.configure do |c|
        c.github_access_token = config['github']['personal_access_token']
        c.base_dir = '~/.gundam'
      end

      repo_service = Gundam::Github::API::V4::Gateway.new

      repo_service.organization_issue('bebanjo', 'movida', 6520)
    end
  end
end
