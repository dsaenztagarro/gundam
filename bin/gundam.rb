# frozen_string_literal: true

unless RUBY_VERSION >= '2.4.0'
  puts 'Required RUBY VERSION >= 2.4.0'
  exit
end

require_relative '../lib/gundam'

require 'thor'
require 'yaml'

require 'benchmark'

config = YAML.load_file(File.expand_path('~/.gundam.yml'))

Gundam.configure do |c|
  c.github_access_token = config['github']['personal_access_token']
  c.base_dir = '~/.gundam'
end

module GundamCli
  class Vim < Thor
    desc 'words ORGANIZATION', 'Create dictionary with Github Team members'
    def words(organization)
      Gundam::CommandRunner.new.run(
        command: Gundam::SetupVimWordsCommand,
        cli_options: { organization: organization }
      )
    end
  end

  class Pull < Thor
    desc 'pull', 'Get pull request'
    option :without_local_repo, type: :boolean
    option :repository, type: :string
    option :number, type: :numeric
    def show
      Gundam::CommandRunner.new.run(
        command: Gundam::ShowPullCommand,
        cli_options: options
      )
    end

    desc 'create', 'Create pull'
    def create
      Gundam::CommandRunner.new.run(command: Gundam::CreatePullCommand)
    end

    desc 'update', 'Update pull'
    def update
      Gundam::CommandRunner.new.run(command: Gundam::UpdatePullCommand)
    end

    desc 'comment', 'Add comment'
    option :without_local_repo, type: :boolean
    option :repository, type: :string
    option :number, type: :numeric
    def comment
      Gundam::CommandRunner.new.run(
        command: Gundam::Commands::CreateComment,
        command_options: { commentable: 'Pull' },
        cli_options: options
      )
    end

    desc 'update_comment', 'Update comment'
    option :comment_id, type: :numeric
    def update_comment
      Gundam::CommandRunner.new.run(
        command: Gundam::Commands::UpdateComment,
        command_options: { commentable: 'Pull' },
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
        command: Gundam::ShowIssueCommand,
        cli_options: options
      )
    end

    desc 'create', 'Create issue'
    def create
      Gundam::CommandRunner.new.run(command: Gundam::CreateIssueCommand)
    end

    desc 'update', 'Update issue'
    def update
      Gundam::CommandRunner.new.run(command: Gundam::UpdateIssueCommand)
    end

    desc 'comment', 'Add comment'
    option :without_local_repo, type: :boolean
    option :repository, type: :string
    option :number, type: :numeric
    def comment
      Gundam::CommandRunner.new.run(
        command: Gundam::Commands::CreateComment,
        command_options: { commentable: 'Issue' },
        cli_options: options
      )
    end

    desc 'update_comment', 'Update comment'
    option :comment_id, type: :numeric
    def update_comment
      Gundam::CommandRunner.new.run(
        command: Gundam::Commands::Comments::Update,
        command_options: { commentable: 'Issue' },
        cli_options: options
      )
    end
  end

  class Comments < Thor
  end

  class Base < Thor
    desc 'vim SUBCOMMAND ...ARGS', 'manage set of vim requests'
    subcommand 'vim', GundamCli::Vim

    desc 'issue SUBCOMMAND ...ARGS', 'manage set of issue requests'
    subcommand 'issue', GundamCli::Issue

    desc 'pull SUBCOMMAND ...ARGS', 'manage set of pull requests'
    subcommand 'pull', GundamCli::Pull

    desc 'comments SUBCOMMAND ...ARGS', 'manage set of pull requests'
    subcommand 'comments', GundamCli::Comments
  end
end

GundamCli::Base.start(ARGV)
