# frozen_string_literal: true

begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb'] # optional
    t.options = ['--any', '--extra', '--opts'] # optional
    t.stats_options = ['--list-undoc']         # optional
  end
rescue Load::Error
  puts 'Yard task not loaded'
end
