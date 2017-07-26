require 'English' # needed by $CHILD_STATUS
require_relative 'gundam/configurable'
require_relative 'gundam/commands/command'

module Gundam
  class << self
    include Gundam::Configurable
  end
end
