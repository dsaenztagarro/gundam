# frozen_string_literal: true

require 'open3'

module Gundam
  module Git
    class Repository
      attr_reader :dir, :log

      # @param dir [String] local dir path of a git repository
      # @param log [StringIO] log buffer
      def initialize(dir, log = StringIO.new)
        @dir = dir.freeze
        @log = log
      end

      def platform_hostname
        remote_attributes['hostname']
      end

      def owner
        remote_attributes['owner']
      end

      def name
        remote_attributes['name']
      end

      def full_name
        "#{owner}/#{name}"
      end

      def platform_constant_name
        case platform_hostname
        when 'github.com' then 'Github'
        end
      end

      # Getters
      #

      def current_branch
        @current_branch ||=
          Dir.chdir(dir) { `git rev-parse --abbrev-ref HEAD`.chomp }
      end

      def exist_remote_branch?
        run do
          `git ls-remote --exit-code --heads #{remote_origin_url} #{current_branch}`
          $CHILD_STATUS.exitstatus == 0
        end
      end

      def push_set_upstream
        run { `git push --set-upstream origin #{current_branch}` }
      end

      private

      def remote_attributes
        @remote_attributes ||=
          /git@(?<hostname>.*):(?<owner>.*)\/(?<name>.*).git/.match(remote_origin_url)
      end

      def remote_origin_url
        Dir.chdir(dir) { `git config --get remote.origin.url`.chomp }
      end

      def run
        Dir.chdir(dir) { yield }
      end
    end
  end
end
