module Platforms
  module Github
    module API
      module V3
        module Gateways
          class PullRequestGateway < Platforms::Github::API::V3::Gateways::Base
            def to_h
              {
                body:                resource[:body],
                created_at:          resource[:created_at],
                created_by:          resource[:user][:login],
                head_sha:            resource[:head][:sha],
                head_repo_full_name: resource[:head][:repo][:full_name],
                html_url:            resource[:_links][:html][:href],
                number:              resource[:number],
                source_branch:       resource[:head][:ref],
                target_branch:       resource[:base][:ref],
                title:               resource[:title],
                updated_at:          resource[:updated_at],
              }
            end
          end
        end
      end
    end
  end
end
