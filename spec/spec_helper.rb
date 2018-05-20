# frozen_string_literal: true

require 'simplecov'
require 'coveralls'
require 'byebug'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 Coveralls::SimpleCov::Formatter
                                                               ])

SimpleCov.start do
  add_filter 'spec/'
end

require 'webmock/rspec'

require_relative '../lib/gundam'
require_relative '../lib/gundam/github/gateway'

Dir.glob(File.expand_path('support/**/*.rb', __dir__)).each { |file| load file }

tmpdir = Dir.mktmpdir

Gundam.configure do |c|
  c.github_access_token = '0123456789'
  c.base_dir = tmpdir
end

RSpec.configure do |config|
  # Enables the --only-failures option
  config.example_status_persistence_file_path = 'examples.txt'

  config.after(:suite) do
    FileUtils.remove_entry(tmpdir)
  end
end
