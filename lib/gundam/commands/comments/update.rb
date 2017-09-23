# frozen_string_literal: true

module Gundam
  module Commands
    class UpdateCommentCommand < Gundam::Command
      include Commands::Shared::DecoratorHelper
      include Gundam::Commands::Shared::FileHelper

      def_delegators :context, :cli_options, :command_options # base context
      def_delegators :context, :repository, :repo_service # context with repository

      def run
        commentable = commentable_finder.find

        comment = repo_service.issue_comment(repository, comment_id)
        original_text = comment.body

        filepath = create_file(new_comment_filename(commentable), original_text)

        doc = edit_file(filepath)
        return if doc.content.eql?(original_text)

        comment = update_comment(commentable, doc)

        puts decorate(comment).string_on_create
      end

      private

      def new_comment_filename(commentable)
        number = commentable.number
        "#{file_repo}_issue_#{number}_comment_#{comment_id}_#{file_timestamp}.md"
      end

      def commentable_finder
        finder_klass_name = "#{command_options[:commentable]}Finder"
        finder_klass = Gundam.const_get(finder_klass_name)
        finder_klass.new(context)
      end

      def	comment_id
        cli_options[:comment_id]
      end

      def update_comment(commentable, doc)
        repo_service.update_comment(repository, comment_id, doc.content)
      end
    end
  end
end
