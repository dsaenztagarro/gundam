module Gundam
  module Github
    module API
      module V3
        class IssueMapper
          # @param resource [Sawyer::Resource]
          def self.load(resource)
            Gundam::Issue.new(
							html_url: resource[:html_url],
              body:     resource[:body],
              number:   resource[:number],
              title:    resource[:title],
              labels:   resource[:labels].map { |lab| LabelMapper.load(lab) }
            )
          end
        end
      end
    end
  end
end
