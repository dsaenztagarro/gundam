require_relative '../helpers/tty_helper'

class Command
  include TTYHelper

  def default_profile
    Profiles::Bebanjo::Configuration.new
  end
end
