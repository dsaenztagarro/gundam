module Gundam
  module Github
    module API
      module V4
        class IssueQuery < Query
          def initialize(login, repo, number, options = {})
            @login   = login
            @repo    = repo
            @number  = number
            @options = options
          end

          def query
            template = <<~GRAPHQL
              query {
                repository(owner: "#{@login}", name: "#{@repo}") {
                  issue(number: #{@number}) {
                    number
                    title
                    body
                    repository {
                      nameWithOwner
                    }
                    author {
                      login
                    }
                    assignees (first: 10) {
                      edges {
                        node {
                          login
                        }
                      }
                    }
                    labels(first: 10) {
                      edges {
                        node {
                          id
                          name
                          color
                        }
                      }
                    }
                    <% if @options[:with_comments] %>
                    comments (last: 100) {
                      nodes {
                        id
                        author {
                          login
                        }
                        body
                        publishedAt
                      }
                    }
                    <% end %>
                  }
                }
              }
            GRAPHQL

            ERB.new(template, 0, '>').result(binding)
          end
        end
      end
    end
  end
end
