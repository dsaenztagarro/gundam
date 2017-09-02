# frozen_string_literal: true

GC.disable

require_relative 'dependencies'

module Gundam
  class << self
    include Configurable
  end
end
