module Gundam
  module Context
    module WithRepository
      def local_repo?
        !cli_options.include?(:repository)
      end

      def local_repo
        @local_repo ||= LocalRepository.at(base_dir) ||
                          raise(Gundam::LocalRepoNotFound.new(base_dir))
      end

      def repository
        if local_repo?
          local_repo.full_name
        else
          cli_options[:repository]
        end
      end

      def repo_service
        if local_repo?
          local_repo.repo_service
        else
          platform_constant_name = cli_option_or_error(:platform_constant_name)
          RepoServiceFactory.with_platform(platform_constant_name).build
        end
      end

      private

      def cli_option_or_error(key)
        cli_options[key] or raise ArgumentError.new("Missing cli option #{key}")
      end
    end
  end
end
