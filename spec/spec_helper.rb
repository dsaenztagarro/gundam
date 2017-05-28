require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter 'spec/'
end

require 'webmock/rspec'
require 'json'

Dir.glob(File.expand_path "../../lib/**/*.rb", __FILE__).each { |file| load file }

Dir.glob(File.expand_path "../support/**/*.rb", __FILE__).each { |file| load file }

Gundam.configure do |c|
  c.github_access_token = "0123456789"
end
