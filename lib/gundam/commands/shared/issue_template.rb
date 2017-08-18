module Gundam
  module Commands
    module Shared
      module IssueTemplate
        def load_template_from(issue)
          assignee = issue.assignee
          body     = issue.body
          labels   = issue.labels.map(&:name).join(', ')
          title    = issue.title
          renderer = ERB.new(get_template)
          renderer.result(binding)
        end

        def get_template
          <<~END
            ---
            title: <%= title %>
            assignee: <%= assignee %>
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
