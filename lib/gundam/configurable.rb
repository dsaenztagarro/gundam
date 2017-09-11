# frozen_string_literal: true

module Gundam
  module Configurable
    attr_accessor :github_access_token, :default_locale, :stdout, :theme, :zone

    attr_writer :base_dir

    def configure
      yield self
    end

    def base_dir
      File.expand_path(@base_dir)
    end
  end
end
