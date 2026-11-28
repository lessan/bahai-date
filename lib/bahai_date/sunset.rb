require "date"

module BahaiDate
  # Time of sunset, from the sunrise/sunset algorithm in the _Almanac for
  # Computers_ (Nautical Almanac Office, United States Naval Observatory, 1990),
  # as published by the Naval Observatory and implemented in the RubySunrise gem
  # (MIT licence), which this gem used until 2.0.0.
  #
  # It is a short approximation: the Sun's position comes from the day of the
  # year and constants for the present era, with no terms for the year itself,
  # so it slowly loses accuracy as the Earth's orbit changes over the
  # centuries. See Logic::MAX_GREGORIAN_YEAR for how much that matters.
  module Sunset
    # The Sun's centre 90 degrees 50 minutes from the zenith: the Sun's
    # semi-diameter plus standard atmospheric refraction at the horizon.
    OFFICIAL_ZENITH = 90.833333

    # The moment of sunset on the given date at the given place, as a UTC Time
    # truncated to the minute, or nil if the Sun does not set that day (polar
    # summer or winter). The truncation is RubySunrise's: keeping it means the
    # gem gives the same dates it always has (keeping the seconds moves
    # Naw-Ruz in 2418 by a day, where the equinox is within a minute of sunset).
    def self.utc(date, latitude, longitude, zenith = OFFICIAL_ZENITH)
      longitude_hour = longitude / 15.0
      t = date.yday + (18.0 - longitude_hour) / 24.0

      mean_anomaly = 0.9856 * t - 3.289
      true_longitude = normalize(
        mean_anomaly + 1.916 * sin(mean_anomaly) + 0.020 * sin(2 * mean_anomaly) + 282.634, 360.0
      )

      # Right ascension, in the same quadrant as the true longitude, in hours.
      right_ascension = normalize(degrees(Math.atan(0.91764 * tan(true_longitude))), 360.0)
      right_ascension += (true_longitude / 90.0).floor * 90.0 - (right_ascension / 90.0).floor * 90.0
      right_ascension /= 15.0

      sin_declination = 0.39782 * sin(true_longitude)
      cos_declination = Math.cos(Math.asin(sin_declination))
      cos_hour_angle = (cos(zenith) - sin_declination * sin(latitude)) / (cos_declination * cos(latitude))
      return nil unless (-1.0..1.0).cover?(cos_hour_angle)

      hour_angle = degrees(Math.acos(cos_hour_angle)) / 15.0
      local_mean_time = hour_angle + right_ascension - 0.06571 * t - 6.622
      hours = normalize(local_mean_time - longitude_hour, 24.0)
      # hours is a UTC time of day. Sunset is near 18:00 local mean time, so
      # pick the UTC day that puts it there: far west of Greenwich sunset falls
      # on the next UTC day, far east on the previous one.
      expected = 18.0 - longitude_hour
      hours += [-24.0, 0.0, 24.0].min_by { |shift| (hours + shift - expected).abs }

      Time.utc(date.year, date.month, date.day) + (hours * 60).floor * 60
    end

    def self.normalize(value, range)
      value % range
    end

    def self.sin(degrees) = Math.sin(radians(degrees))

    def self.cos(degrees) = Math.cos(radians(degrees))

    def self.tan(degrees) = Math.tan(radians(degrees))

    def self.radians(degrees) = degrees * Math::PI / 180.0

    def self.degrees(radians) = radians * 180.0 / Math::PI

    private_class_method :normalize, :sin, :cos, :tan, :radians, :degrees
  end
end
