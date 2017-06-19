unless RUBY_VERSION == '2.4.0'
  puts "Run first 'rvm wrapper ruby-2.4.0'"
  exit
end

require 'thor'
require 'yaml'

Dir.glob(File.expand_path "../../lib/**/*.rb", __FILE__).each { |file| load file }

config = YAML.load_file(File.expand_path '~/.gundam.yml')

Gundam.configure do |c|
  c.github_access_token = config['github']['personal_access_token']
end

class GundamCli < Thor
  desc 'create_pull', 'Create pull request'
  def create_pull
    CreatePullRequestCommand.new.run
  end

  desc 'show_pull', 'Get pull request'
  option :number, :type => :numeric
  option :with_comments, :type => :boolean
  option :with_statuses, :type => :boolean
  def show_pull
    GetPullRequestCommand.new.run(options)
  end

  desc 'show_issue', 'Get issue'
  option :number, :type => :numeric
  option :with_comments, :type => :boolean
  def show_issue
    GetIssueCommand.new.run(options)
  end
end

GundamCli.start(ARGV)
