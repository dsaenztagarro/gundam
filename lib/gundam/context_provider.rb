module Gundam
  class ContextProvider
    def load_context(options)
      @options = options

      options[:pull] ? pull_local_repo_context : issue_local_repo_context
    end

    private

    attr_reader :options

    def base_dir
      options[:base_dir] || Dir.pwd
    end

    def local_repo
      @local_repo ||= LocalRepository.at(base_dir) ||
                        raise(Gundam::LocalRepoNotFound.new(base_dir))
    end

    def issue_local_repo_context
      CommandContext.new(
        repository: local_repo.full_name,
        number: options[:number] || local_repo.current_branch.to_i,
        service: local_repo.service
      )
    end
  end
end
