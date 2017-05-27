require 'coveralls'
Coveralls.wear!

require 'webmock/rspec'
require 'json'
require 'byebug'

Dir.glob(File.expand_path "../../lib/**/*.rb", __FILE__).each { |file| load file }

Dir.glob(File.expand_path "../support/**/*.rb", __FILE__).each { |file| load file }

Gundam.configure do |c|
  c.github_access_token = "0123456789"
end
