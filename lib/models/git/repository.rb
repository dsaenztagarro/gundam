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

    def platform_client
      client_klass_name = "Platforms::#{platform_constant_name}::Client"
      client_klass = Kernel.const_get(client_klass_name)
      client_klass.new
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

    # Checkers
    #

    # @return [Boolean] Marks whether or not are changes pending to be commited
    def uncommited_changes?
      run 'git status --porcelain' do |outerr, _status|
        !outerr.chomp.empty?
      end
    end

    def unpushed_commits?
      run "git log origin/#{current_branch}..#{current_branch}" do |outerr, _|
        !outerr.chomp.empty?
      end
    end

    # @return [Boolean] Marks whether it is configured a remote upstream for
    #   current branch
    def remote?
      !`git config branch.#{current_branch}.remote`.chomp.empty?
    end

    # Actions
    #

    def push
      if remote?
        run 'git push'
      else
        run "git push --set-upstream origin #{current_branch}"
      end
    end

    def as_json
      { type: 'git',
        dir: dir,
        branch: current_branch }
    end

    private

    def run(command)
      Dir.chdir(dir) do
        outerr, status = ::Open3.capture2e(command)
        log.puts "$ #{command}"
        log.puts outerr
        return yield(outerr, status) if block_given?
        status.success?
      end
    end
  end
end
