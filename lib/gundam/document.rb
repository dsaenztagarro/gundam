# frozen_string_literal: true

module Gundam
  class Document
    attr_reader :path
    attr_accessor :content, :data

    YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m

    # @param path [String] The path to the file
    def initialize(path)
      @path = path
    end

    def read
      self.content = File.read(path)
      if content =~ YAML_FRONT_MATTER_REGEXP
        self.content = $POSTMATCH
        self.data = YAML.safe_load(Regexp.last_match(1))
      end
    end
  end
end
