module Gundam
  module Commands
    class UpdateComment < Gundam::Command
      include Gundam::Commands::Shared::FileHelper

      def_delegators :context, :cli_options, :command_options # base context
      def_delegators :context, :repository, :repo_service # context with repository

      def run
        commentable = commentable_finder.find

        comment = repo_service.issue_comment(repository, comment_id)

        filepath = create_file(new_comment_filename(commentable))

        write_file(filepath, comment.body)

        open_file(filepath)

        text = File.read(filepath)
        return if text.empty?

        comment = repo_service.update_comment(repository, comment_id, text)

        puts Gundam::CommentDecorator.new(comment).string_on_create
      end

      private

      def new_comment_filename(commentable)
        repo = repository.tr('/', '_')
        number = commentable.number
        "#{repo}_issue_#{number}_comment_#{comment_id}_#{file_timestamp}.md"
      end

      def commentable_finder
        finder_klass_name = "#{command_options[:commentable]}Finder"
        finder_klass = Gundam.const_get(finder_klass_name)
        finder_klass.new(context)
      end

      def	comment_id
        cli_options[:comment_id]
      end
    end
  end
end