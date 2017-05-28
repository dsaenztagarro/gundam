require 'open3'

module Git
  class Repository
    attr_reader :dir, :log

    # @param dir [String] local dir path of a git repository
    # @param log [StringIO] log buffer
    def initialize(dir, log = StringIO.new)
      @dir = dir.freeze
      @log = log
    end

    def repository_name
      match = /git@(.*):(?<name>.*).git/.match(remote_origin_url)
      match['name'] if match
    end

    def platform_hostname
      match = /git@(?<hostname>.*):(.*).git/.match(remote_origin_url)
      match['hostname'] if match
    end

    def platform_constant_name
      case platform_hostname
      when "github.com" then "Github"
      end
    end

    # Getters
    #

    def remote_origin_url
      @remote_origin_url ||=
        Dir.chdir(dir) { `git config --get remote.origin.url`.chomp }
    end

    def current_branch
      @current_branch ||=
        Dir.chdir(dir) { `git rev-parse --abbrev-ref HEAD`.chomp }
    end
  end
end
