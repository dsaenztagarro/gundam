#!/usr/bin/env ruby-2.4.0

unless RUBY_VERSION == '2.4.0'
  puts "Run first 'rvm wrapper ruby-2.4.0'"
  exit
end

require 'thor'

Dir.glob(File.expand_path "../../lib/**/*.rb", __FILE__).each { |file| load file }

class GundamCli < Thor
  desc 'pr', 'Create pull request'
  def create_pull_request
    CreatePullRequestCommand.new.run
  end

  desc 'ic', 'Get issue comments'
  def get_issue_comments
    GetIssueCommentsCommand.new.run
  end

  map pr: :create_pull_request
  map ic: :get_issue_comments
end

GundamCli.start(ARGV)
