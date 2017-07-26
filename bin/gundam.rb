unless RUBY_VERSION == '2.4.0'
  puts "Run first 'rvm wrapper ruby-2.4.0'"
  exit
end

require 'thor'
require 'yaml'

# load initializers
Dir.glob(File.expand_path '../../config/initializers/*.rb', __FILE__).each { |file| load file }

Dir.glob(File.expand_path '../../lib/**/*.rb', __FILE__).each { |file| load file }

config = YAML.load_file(File.expand_path '~/.gundam.yml')

Gundam.configure do |c|
  c.github_access_token = config['github']['personal_access_token']
  c.base_dir = '~/.gundam'
end

module GundamCli
  class Pull < Thor
    desc 'create', 'Create pull request'
    def create
      Gundam::CommandRunner.new.run(
        command: Gundam::CreatePullRequestCommand)
    end

    desc 'pull', 'Get pull request'
    option :without_local_repo, type: :boolean
    option :repository, type: :string
    option :number, type: :numeric
    def show
      Gundam::CommandRunner.new.run(
        command: Gundam::GetPullRequestCommand,
        cli_options: options
      )
    end
  end

  class Issue < Thor
    desc 'issue', 'Get issue'
    option without_local_repo: :boolean
    option :repository, type: :string
    option :number, type: :numeric
    def show
      Gundam::CommandRunner.new.run(
        command: Gundam::GetIssueCommand,
        cli_options: options
      )
    end
  end

  class Comments < Thor
    desc 'create', 'Add comment'
    option :without_local_repo, type: :boolean
    option :repository, type: :string
    option :number, type: :numeric
    def create
      Gundam::CommandRunner.new.run(
        command: Gundam::Commands::Issue::AddComment,
        cli_options: options)
    end
  end

  class Base < Thor
    desc "issue SUBCOMMAND ...ARGS", "manage set of issue requests"
    subcommand "issue", GundamCli::Issue

    desc "pull SUBCOMMAND ...ARGS", "manage set of pull requests"
    subcommand "pull", GundamCli::Pull

    desc "comments SUBCOMMAND ...ARGS", "manage set of pull requests"
    subcommand "comments", GundamCli::Comments

  end
end

GundamCli::Base.start(ARGV)
