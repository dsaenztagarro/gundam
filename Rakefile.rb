require_relative 'lib/tasks/documentation.rb'
require_relative 'lib/tasks/github_graphql.rb'

task default: ['github:graphql:rate_limit']
