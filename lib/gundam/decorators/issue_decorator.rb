require_relative 'decorator'
require_relative 'helpers/issue_helper'

module Gundam
  class IssueDecorator < Decorator
    include Gundam::IssueHelper

    def show_issue(options)
      io = StringIO.new
      add_description(io) if options[:with_description]
      add_comments(io)    if options[:with_comments]
      io.string
    end
  end
end
