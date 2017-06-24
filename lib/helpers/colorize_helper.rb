require 'pastel'

module ColorizeHelper
  def cyan(text)
    pastel.cyan(text)
  end

  def blue(text)
    pastel.blue(text)
  end

  def green(text)
    pastel.green(text)
  end

  def red(text)
    pastel.red(text)
  end

  private

  def pastel
    @pastel ||= Pastel.new
  end
end
