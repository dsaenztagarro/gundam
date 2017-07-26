require 'byebug'

module Gundam
  module Github
    module API
      module V3
        class IssueMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::Issue.new(
              title: resource[:title],
              body:  resource[:body],
              number: resource[:number]
            )
          end
        end
      end
    end
  end
end
