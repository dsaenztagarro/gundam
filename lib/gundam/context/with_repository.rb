module Gundam
  module Context
    module WithRepository
      def local_repo?
        !cli_options.include?(:without_local_repo)
      end

      def local_repo
        @local_repo ||= LocalRepository.at(base_dir) ||
                          raise(Gundam::LocalRepoNotFound.new(base_dir))
      end

      def repository
        if local_repo?
          local_repo.full_name
        else
          cli_option_or_error(:repository)
        end
      end

      def repo_service
        if local_repo?
          local_repo.service
        else
          platform_constant_name = cli_option_or_error(:platform_constant_name)
          PlatformServiceFactory.with_platform(platform_constant_name).build
        end
      end

      private

      def cli_option_or_error(key)
        cli_options[key] or raise Gundam::CliOptionError.new(key)
      end
    end
  end
end
