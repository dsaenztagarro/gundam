# frozen_string_literal: true

module Gundam
  module Commands
    class CreateComment < Gundam::Command
      include Commands::Shared::DecoratorHelper
      include Gundam::Commands::Shared::FileHelper

      def_delegators :context, :cli_options, :command_options # base context
      def_delegators :context, :repository, :repo_service # context with repository

      def run
        commentable = commentable_finder.find

        filepath = create_file(new_comment_filename(commentable))

        doc = edit_file(filepath)
        return if doc.content.empty?

        comment = repo_service.add_comment(repository, commentable.number, doc.content)

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
    end
  end
end
