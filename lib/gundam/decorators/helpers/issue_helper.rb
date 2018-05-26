# frozen_string_literal: true

module Gundam
  module IssueHelper
    # @param output [StringIO]
    def add_description(output)
      output.puts <<~OUT
        #{red(title)}
        #{reformat_wrapped(body)}
      OUT
    end

    # @param output [StringIO]
    def add_comments(output)
      comments.each do |comment|
        output.puts CommentDecorator.new(comment).string
        output.puts unless comment == comments.last
      end
    end
  end
end
