module Gundam
  class Document
    attr_reader :path
    attr_accessor :content, :data

    YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

    # @param path [String] The path to the file
    def initialize(path)
      @path = path
    end

    def read
      self.content = File.read(path)
      if self.content =~ YAML_FRONT_MATTER_REGEXP
        self.content = $POSTMATCH
        self.data = YAML.load(Regexp.last_match(1))
      end
    end
  end
end
