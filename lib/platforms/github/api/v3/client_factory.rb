require 'octokit'
require 'yaml'

module Platforms
  module Github
    module API
      module V3
        class ClientFactory
          def self.build
            config = YAML.load_file(File.expand_path '~/.gundam.yml')

            github_access_token = config['github']['personal_access_token']

            Octokit::Client.new login: github_access_token,
                                password: 'x-oauth-basic'
          end
        end
      end
    end
  end
end
