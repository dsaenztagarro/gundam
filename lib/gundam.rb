# frozen_string_literal: true

require_relative 'dependencies'

module Gundam
  class << self
    include Configurable
  end

  Error = Class.new(StandardError)
end
