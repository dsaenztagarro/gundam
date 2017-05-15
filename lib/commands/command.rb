class Command
  def initialize(spinner = SpinnerWrapper.new)
    @spinner = spinner
  end

  def default_profile
    Profiles::Bebanjo::Configuration.new(@spinner)
  end
end
