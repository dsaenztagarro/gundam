module Gundam
  module Commands
    module Shared
      module IssueTemplate
        def load_template_from(issue)
          title  = issue.title
          labels = issue.labels.map(&:name).join(', ')
          body   = issue.body
          renderer = ERB.new(get_template)
          renderer.result(binding)
        end

        def get_template
          <<~END
            ---
            title: <%= title %>
            labels: <%= labels %>
            ---
            <%= body %>
          END
        end

        def load_empty_template
          load_template_from(Issue.new)
        end
      end
    end
  end
end
