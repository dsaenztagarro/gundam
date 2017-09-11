module Gundam
  module TimeHelper
    def current_time_zone
      Gundam.zone || Time.now.zone
    end

    def with_time_zone(tz_name)
      prev_tz = ENV['TZ']
      ENV['TZ'] = tz_name
      yield
    ensure
      ENV['TZ'] = prev_tz
    end
  end
end
