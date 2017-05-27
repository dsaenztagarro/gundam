require 'json'

module Platforms
  module Github
    module API
      module V4
        # GraphQL API V4 Connector
        class Connector
          # @param repo [String]
          # @param number [Fixnum]
          # @return [IssueCommentGateway]
          def issue_comments(repo, number)
            login, name = repo.split('/')
            response = run_query IssueCommentsQuery.new(login, name, number).to_s
            IssueCommentGateway.wrap(response)
          end

          private

          def run_query(query)
            config = YAML.load_file(File.expand_path '~/.gundam.yml')
            github_access_token = config['github']['personal_access_token']

            response = Net::HTTP.post URI('https://api.github.com/graphql'),
              { query: query }.to_json,
              "Authorization" => "bearer #{github_access_token}",
              "Content-type" => "application/json"
            JSON.parse(response.body)
          end
        end
      end
    end
  end
end
