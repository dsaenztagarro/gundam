require 'English' # needed by $CHILD_STATUS
require 'forwardable'

require_relative 'gundam/configurable'
require_relative 'gundam/commands/command'
require_relative 'gundam/commands/plugin'
require_relative 'gundam/decorators/decorator'
require_relative 'gundam/decorators/helpers/issue_helper'

module Gundam
  class << self
    include Gundam::Configurable
  end
end
