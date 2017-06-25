module Gundam
  module IssueHelper
    # @param output [StringIO]
    def add_description(output)
      output.puts <<~END
        #{red(title)}
        #{body}
      END
    end

    # @param output [StringIO]
    def add_comments(output)
      comments.each do |comment|
        output.puts Gundam::CommentDecorator.new(comment).string
      end
    end
  end
end
