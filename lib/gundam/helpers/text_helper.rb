# frozen_string_literal: true

module Gundam
  module TextHelper
    def reformat_wrapped(text, width = 80)
      lines = []
      paragraphs = text.split(/\n/)
      paragraphs.each do |paragraph|
        lines += reformat_wrapped_paragraph(paragraph, width)
      end
      lines.join("\n") + (text.end_with?("\n") ? "\n" : '')
    end

    private

    def reformat_wrapped_paragraph(text, width)
      lines = []
      line = ''
      indentation = text[/\A */].size
      text.split(/\s+/).each do |word|
        if line.size + word.size >= (width - indentation)
          lines << (' ' * indentation) + line
          line = word
        elsif line.empty?
          line = word
        else
          line << ' ' << word
        end
      end
      lines << (' ' * indentation) + line if line
      lines
    end
  end
end
