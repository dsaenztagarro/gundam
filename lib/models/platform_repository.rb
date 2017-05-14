class PlatformRepository
  attr_reader :name, :default_branch

  def initialize(name:, default_branch: )
    @name           = name
    @default_branch = default_branch
  end
end
