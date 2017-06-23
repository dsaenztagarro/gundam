module Gundam
  class Command
    def initialize(base_dir: Dir.pwd, spinner: SpinnerWrapper.new)
      @base_dir = base_dir
      @spinner = spinner
    end

    def default_profile
      Profiles::Bebanjo::Configuration.new(@spinner)
    end
  end
end
