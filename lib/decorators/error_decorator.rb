require_relative 'decorator'

class ErrorDecorator < Decorator
  def message
    return cause.message if cause
    super
  end

  def to_s
    red(message)
  end
end
