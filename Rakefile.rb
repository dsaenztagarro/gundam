begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb'] # optional
    t.options = ['--any', '--extra', '--opts'] # optional
    t.stats_options = ['--list-undoc']         # optional
  end
rescue Load::Error
  puts 'Yard task not loaded'
end

require_relative 'lib/tasks/github_graphql_tasks'

task default: ['github:graphql:test']
