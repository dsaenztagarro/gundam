# frozen_string_literal: true

unless RUBY_VERSION >= '2.4.0'
  puts 'Required RUBY VERSION >= 2.4.0'
  exit
end

require_relative '../lib/gundam'

require 'yaml'

config = YAML.load_file(File.expand_path('~/.gundam.yml'))

Gundam.configure do |c|
  c.github_access_token = config['github']['personal_access_token']
  c.base_dir = '~/.gundam'
end

REGISTERED_COMMANDS = {
  "issues:show"     => "Gundam::Commands::ShowIssueCommand",
  "issues:create"   => "Gundam::Commands::CreateIssueCommand",
  "issues:update"   => "Gundam::Commands::UpdateIssueCommand",
  "comments:create" => "Gundam::Commands::CreateCommentCommand",
  "comments:update" => "Gundam::Commands::UpdateCommentCommand",
  "pulls:show"      => "Gundam::Commands::ShowPullCommand",
  "pulls:create"    => "Gundam::Commands::CreatePullCommand"
}

runner = Gundam::CommandRunner.new(REGISTERED_COMMANDS)

runner.run(command_key: ARGV[0])
