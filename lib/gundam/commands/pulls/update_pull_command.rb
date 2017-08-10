module Gundam
  class UpdatePullCommand < Gundam::Command
    include Gundam::Commands::Shared::FileHelper

    def_delegators :context, :cli_options, :command_options # base context
    def_delegators :context, :repository, :repo_service # context with repository

    def run
      pull = PullFinder.new(context).find
      original_text = pull.body

      filepath = create_file(edit_pull_filename(pull), original_text)

      new_text = edit_file(filepath)
      return if new_text.eql?(original_text)

      pull = repo_service.update_pull_request(repository, pull.number, new_text)

      puts Gundam::PullRequestDecorator.new(pull).string_on_update
    end

    private

    def edit_pull_filename(pull)
      repo = repository.tr('/', '_')
      "#{repo}_pulls_#{pull.number}_#{file_timestamp}.md"
    end
  end
end
