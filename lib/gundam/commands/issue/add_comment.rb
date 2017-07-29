module Gundam
  module Commands
    module Issue
      class AddComment < Gundam::Command
        def_delegators :context, :cli_options, :command_options # base context
        def_delegators :context, :repository, :repo_service # context with repository

        def run
          commentable = commentable_finder.find

          filepath = create_file(new_comment_filename(commentable))

          open_file(filepath)

          text = File.read(filepath)
          return if text.empty?

          comment = repo_service.add_comment(repository, commentable.number, text)

          puts Gundam::CommentDecorator.new(comment).string_on_create
        end

        private

        def new_comment_filename(commentable)
          timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
          repo = repository.tr('/', '_')
          number = commentable.number
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

        def commentable_finder
          finder_klass_name = "#{command_options[:commentable]}Finder"
          finder_klass = Gundam.const_get(finder_klass_name)
          finder_klass.new(context)
        end
      end
    end
  end
end
