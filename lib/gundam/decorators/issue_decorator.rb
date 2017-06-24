require_relative 'decorator'
require_relative 'helpers/issue_helper'

module Gundam
  class IssueDecorator < Decorator
    include Gundam::IssueHelper

    def show_issue(options)
      io = StringIO.new
      io << show_description if options[:with_description]
      io << show_comments if options[:with_comments]
      io.string
    end
  end
end
