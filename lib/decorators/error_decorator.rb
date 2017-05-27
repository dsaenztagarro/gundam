require_relative '../helpers/colorize_helper'

class ErrorDecorator < SimpleDelegator
  include ColorizeHelper

  def message
    cause.message || super
  end

  def to_s
    red(message)
  end
end
