module Gundam
  class Label
    attr_accessor :color, :id, :name

    def initialize(options = {})
      @id    = options[:id]
      @color = options[:color]
      @name  = options[:name]
    end
  end
end
