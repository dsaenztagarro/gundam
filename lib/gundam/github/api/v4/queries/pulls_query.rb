# frozen_string_literal: true

module Gundam
  module Github
    module API
      module V4
        class PullsQuery < Query
          def initialize(owner, repo, head, options = {})
            @owner   = owner
            @repo    = repo
            @head    = head
            @options = options
          end

          def query
            template = <<~GRAPHQL
              query {
                repository(owner: "#{@owner}", name: "#{@repo}") {
                  pullRequests(headRefName: "#{@head}", first: 10) {
                    edges {
                      node  {
                        title
                        body
                        <% if @options[:expanded] %>
                        comments (last: 100) {
                          nodes {
                            databaseId
                            author {
                              login
                            }
                            body
                            publishedAt
                          }
                        }
                        commits(last: 1) {
                          nodes {
                            commit {
                              status {
                                state
                                contexts {
                                  targetUrl
                                  state
                                  description
                                }
                              }
                            }
                          }
                        }
                        <% end %>
                      }
                    }
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
