require 'pastel'

module ColorizeHelper
  def magenta(text)
    pastel.magenta(text)
  end

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
