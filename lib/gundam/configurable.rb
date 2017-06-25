module Gundam
  module Configurable
    attr_accessor :github_access_token, :default_locale

    attr_writer :base_dir

    def configure
      yield self
    end

    def base_dir
      File.expand_path(@base_dir)
    end
  end
end
