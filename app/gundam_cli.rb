require 'thor'

Dir.glob(File.expand_path "../../lib/**/*.rb", __FILE__).each { |file| load file }

class GundamCli < Thor
  desc 'pr', 'creates pull request'
  def pr
    CreatePullRequestCommand.new.run
  end
end

GundamCli.start(ARGV)
