# frozen_string_literal: true

module TimeHelper
  def with_utc_time_zone
    prev_tz = ENV['TZ']
    ENV['TZ'] = 'UTC'
    yield
  ensure
    ENV['TZ'] = prev_tz
  end
end

RSpec.configure do |config|
  config.include TimeHelper
end
