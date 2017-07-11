require_relative 'query'

module Gundam
  module Github
    module API
      module V4
        class IssueQuery < Gundam::Github::API::V4::Query
          def initialize(login, repo, number)
            @login  = login
            @repo   = repo
            @number = number
          end

          def key
            "issue-#{@login}-#{@repo}-#{@number}"
          end

          def query
            <<~END
              query {
                repositoryOwner(login: "#{@login}") {
                  repository(name: "#{@repo}") {
                    issue(number: #{@number}) {
                      number
                      title
                      bodyText
                      author {
                        login
                      }
                      comments (last: 10) {
                       nodes {
                         id
                         author {
                           login
                         }
                         bodyText
                         publishedAt
                       }
                      }
                    }
                  }
                }
              }
            END
          end
        end
      end
    end
  end
end
