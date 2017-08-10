module Gundam
  module Commands
    class CreateComment < Gundam::Command
      include Gundam::Commands::Shared::FileHelper

      def_delegators :context, :cli_options, :command_options # base context
      def_delegators :context, :repository, :repo_service # context with repository

      def run
        commentable = commentable_finder.find

        filepath = create_file(new_comment_filename(commentable))

        text = edit_file(filepath)
        return if text.empty?

        comment = repo_service.add_comment(repository, commentable.number, text)

        puts Gundam::CommentDecorator.new(comment).string_on_create
      end

      private

      def new_comment_filename(commentable)
        repo = repository.tr('/', '_')
        number = commentable.number
        "#{repo}_issue_#{number}_comment_#{file_timestamp}.md"
      end

      def commentable_finder
        finder_klass_name = "#{command_options[:commentable]}Finder"
        finder_klass = Gundam.const_get(finder_klass_name)
        finder_klass.new(context)
      end
    end
  end
end
