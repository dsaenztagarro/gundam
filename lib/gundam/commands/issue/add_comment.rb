module Gundam
  module Commands
    module Issue
      class AddComment < Gundam::Command
        def_delegators :context, :cli_options # base context
        def_delegators :context, :repository, :repo_service # context with repository

        def run
          filepath = create_file(new_comment_filename)

          open_file(filepath)

          text = File.read(filepath)
          return if text.empty?

          comment = repo_service.add_comment(repository, cli_options[:number], text)

          puts Gundam::CommentDecorator.new(comment).string_on_create
        end

        private

        def new_comment_filename
          timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
          repo = repository.tr('/', '_')
          number = cli_options[:number]
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
