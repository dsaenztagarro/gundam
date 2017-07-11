require 'simplecov'
require 'coveralls'
require 'byebug'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter])

SimpleCov.start do
  add_filter 'spec/'
end

require 'webmock/rspec'
require 'json'

# load initializers
Dir.glob(File.expand_path '../../config/initializers/*.rb', __FILE__).each { |file| load file }

require_relative '../lib/gundam'

Dir.glob(File.expand_path '../../lib/**/*.rb', __FILE__).each { |file| load file }

Dir.glob(File.expand_path '../support/**/*.rb', __FILE__).each { |file| load file }

tmpdir = Dir.mktmpdir

Gundam.configure do |c|
  c.github_access_token = '0123456789'
  c.base_dir = tmpdir
end

RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.remove_entry(tmpdir)
  end
end
