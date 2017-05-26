require 'pastel'

module ColorizeHelper
  def red(text)
    pastel.red(text)
  end

  private

  def pastel
    @pastel ||= Pastel.new
  end
end
