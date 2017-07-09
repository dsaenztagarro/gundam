module Gundam
  module Github
    module API
      module V3
        class RemoteRepositoryMapper

          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::RemoteRepository.new(
              default_branch: resource[:default_branch],
              full_name: resource[:full_name],
              name: resource[:name],
              owner: resource[:owner][:login]
            )
          end
        end
      end
    end
  end
end
