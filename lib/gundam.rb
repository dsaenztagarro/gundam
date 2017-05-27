require_relative 'gundam/configurable'

module Gundam
  class << self
    include Gundam::Configurable
  end
end
