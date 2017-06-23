module Gundam
  module Configurable
    attr_accessor :github_access_token, :default_locale

    def configure
      yield self
    end
  end
end
