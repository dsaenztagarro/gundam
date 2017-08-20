module Gundam
  module Github
    module API
      module V3
        class PullRequestMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::Pull.new(
              body:                resource[:body],
              created_at:          resource[:created_at],
              created_by:          resource[:user][:login],
              head_sha:            resource[:head][:sha],
              head_repo_full_name: resource[:head][:repo][:full_name],
              html_url:            resource[:_links][:html][:href],
              number:              resource[:number],
              repository:          resource[:base][:repo][:full_name],
              source_branch:       resource[:head][:ref],
              target_branch:       resource[:base][:ref],
              title:               resource[:title],
              updated_at:          resource[:updated_at]
            )
          end
        end
      end
    end
  end
end
