require 'English' # needed by $CHILD_STATUS
require 'forwardable'
require_relative 'gundam/configurable'
require_relative 'gundam/commands/command'

module Gundam
  class << self
    include Gundam::Configurable
  end
end
