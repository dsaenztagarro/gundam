module Gundam
  class RemoteRepository
    attr_reader :name, :owner, :full_name, :default_branch

    def initialize(name:, owner:, full_name:, default_branch:)
      @name           = name
      @owner          = owner
      @full_name      = full_name
      @default_branch = default_branch
    end
  end
end
