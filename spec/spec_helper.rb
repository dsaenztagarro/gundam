require 'coveralls'
Coveralls.wear!

require 'json'

Dir.glob(File.expand_path "../../lib/**/*.rb", __FILE__).each { |file| load file }

Dir.glob(File.expand_path "../support/**/*.rb", __FILE__).each { |file| load file }
