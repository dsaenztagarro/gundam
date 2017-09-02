module Gundam
  module TextHelper
    def reformat_wrapped(s, width=80)
      lines = []
      line = ""
      s.split(/\s+/).each do |word|
        if line.size + word.size >= width
          lines << line
          line = word
        elsif line.empty?
          line = word
        else
          line << " " << word
        end
      end
      lines << line if line
      return lines.join "\n"
    end
  end
end
