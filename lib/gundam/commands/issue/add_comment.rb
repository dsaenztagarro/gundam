require 'forwardable'
require_relative '../shared/local_repo_ext'

module Gundam
  module Commands
    module Issue
      class AddComment
        extend Forwardable

        def_delegators :@context, :repository, :number, :service

        # @param context [CommandContext]
        def run(context)
          @context = context

          filepath = create_file(new_comment_filename)

          open_file(filepath)

          text = File.read(filepath)
          return if text.empty?

          comment = context.service.add_comment(repository, number, text)

          puts Gundam::CommentDecorator.new(comment).string_on_create
        end

        private

        def new_comment_filename
          timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
          repo = repository.tr('/', '_')
          "#{repo}_issue_#{number}_comment_#{timestamp}.md"
        end

        def create_file(filename)
          File.join(Gundam.base_dir, 'files', filename).tap do |filepath|
            FileUtils.mkdir_p File.dirname(filepath)
            FileUtils.touch(filepath)
          end
        end

        def open_file(filepath)
          system("$EDITOR #{filepath}")
        end
      end
    end
  end
end
