require 'forwardable'
require_relative 'command'

module Gundam
  class GetIssueCommand < Command
    extend Forwardable

    def_delegators :@context, :repository, :number, :service, :original_options

    # @param context [CommandContext]
    def run(context)
      @context = context

      issue = service.issue(repository, number)
      if with_comments?
        issue.comments = service.issue_comments(repository, number)
      end

      puts Gundam::IssueDecorator.new(issue).show_issue(original_options)
    rescue Gundam::IssueNotFound => error
      Gundam::ErrorHandler.handle(error)
    rescue Platforms::Unauthorized => error
      puts ErrorDecorator.new(error)
    end

    private

    def with_comments?
      original_options[:with_comments]
    end
  end
end
