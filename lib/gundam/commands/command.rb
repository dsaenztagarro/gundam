module Gundam
  class Command
    def initialize(base_dir: Dir.pwd)
      @base_dir = base_dir
    end

    def default_profile
      Profiles::Bebanjo::Configuration.new
    end
  end
end
