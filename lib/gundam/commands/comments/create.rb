# frozen_string_literal: true

module Gundam
  module Commands
    class CreateCommentCommand < Gundam::Command
      include Shared::DecoratorHelper
      include Shared::FileHelper

      def_delegators :context, :cli_options, :command_options # base context
      def_delegators :context, :repository, :repo_service # context with repository

      def run
        commentable = commentable_finder.find

        filepath = create_file(new_comment_filename(commentable))

        doc = edit_file(filepath)
        return if doc.content.empty?

        comment = add_comment(commentable, doc)

        puts decorate(comment).string_on_create
      end

      private

      def new_comment_filename(commentable)
        number = commentable.number
        "#{file_repo}_issue_#{number}_comment_#{file_timestamp}.md"
      end

      def commentable_finder
        finder_klass_name = "#{command_options[:commentable]}Finder"
        finder_klass = Gundam.const_get(finder_klass_name)
        finder_klass.new(context)
      end

      def add_comment(commentable, doc)
        repo_service.add_comment(repository, commentable.number, doc.content)
      end
    end
  end
end
