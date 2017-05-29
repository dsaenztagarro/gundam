module Gundam
  module Configurable
    attr_accessor :github_access_token

    def configure
      yield self
    end
  end
end
