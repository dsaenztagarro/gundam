module Gundam
  module IssueHelper
    def show_description
      <<~END
      #{red(title)}
      #{body}
      END
    end

    def show_comments
      io = StringIO.new
      comments.each { |comment| io.puts show_comment(comment) }
      io.string
    end

    private

    def show_comment(comment)
      <<~END
      #{cyan(comment.user_login)} #{blue(comment.updated_at)}
      #{comment.body}
      END
    end
  end
end
