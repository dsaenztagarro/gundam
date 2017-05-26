unless RUBY_VERSION == '2.4.0'
  puts "Run first 'rvm wrapper ruby-2.4.0'"
  exit
end

require 'thor'
require 'byebug'

Dir.glob(File.expand_path "../../lib/**/*.rb", __FILE__).each { |file| load file }

class GundamCli < Thor
  desc 'cpr', 'Create pull request'
  def create_pull_request
    CreatePullRequestCommand.new.run
  end

  desc 'i', 'Get issue'
  def get_issue
    GetIssueCommand.new.run
  end

  desc 'gic', 'Get issue comments'
  def get_issue_comments
    GetIssueCommentsCommand.new.run
  end

  map cpr: :create_pull_request
  map i: :get_issue
  map gic: :get_issue_comments
end

GundamCli.start(ARGV)
