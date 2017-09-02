# frozen_string_literal: true

module Gundam
  module Github
    module API
      module V3
        class CommentMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Comment.new(
              body:       resource[:body],
              created_at: resource[:created_at],
              html_url:   resource[:html_url],
              id:         resource[:id],
              updated_at: resource[:updated_at],
              author:     resource[:user][:login]
            )
          end
        end
      end
    end
  end
end
