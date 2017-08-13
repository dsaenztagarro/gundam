require 'erb'
require 'byebug'

module Gundam
  class CreateIssueCommand < Command
    include Commands::Shared::DecoratorHelper
    include Commands::Shared::FileHelper

    def_delegators :context, :cli_options, :command_options # base context
    def_delegators :context, :repository, :repo_service # context with repository

    def run
      filepath = create_issue_file

      edit_file(filepath)
      doc = Document.new(filepath)
      doc.read

      issue = create_issue(doc)

      puts decorate(issue).string_on_create
    end

    private

    def create_issue_file
      create_file(issue_filename, load_issue_template)
    end

    def issue_filename
      "#{file_repo}_issues_#{file_timestamp}.md"
    end

    def create_issue(doc)
      title   = doc.data['title']
      body    = doc.content
      options = doc.data.select { |key, _| key == 'labels' }
      repo_service.create_issue(repository, title, body, options)
    end

    def load_issue_template
      renderer = ERB.new(get_template)
      renderer.result()
    end

    def get_template
      <<~END
        ---
        title:
        labels:
        ---
      END
    end
  end
end
