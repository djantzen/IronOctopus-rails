module Charts
  class ByDayActivityMeasurements < Day

    def full_date
      attributes["full_date"]
    end

    def cadence(units)
      attributes["cadence"].to_i
    end

    def calories(units)
      attributes["calories"].to_i
    end

    def distance(units)
      meters = attributes["distance"].to_f
      units == "english" ? Unit.convert_from_meters(meters, Unit::MILE) : Unit.convert_from_meters(meters, Unit::KILOMETER)
    end

    def duration(units)
      seconds = attributes["duration"].to_f
      seconds <= 60 ? seconds : seconds / 60
    end

    def heartrate(units)
      attributes["heart_rate"].to_i
    end

    def incline(units)
      attributes["incline"].to_i
    end

    def level(units)
      attributes["level"].to_i
    end

    def repetitions(units)
      attributes["repetitions"].to_i
    end

    def resistance(units)
      kilograms = attributes["resistance"].to_f
      units == "english" ? Unit.convert_from_kilograms(kilograms, Unit::POUND) : kilograms
    end

    def speed(units)
      kilometers_per_hour = attributes["speed"].to_f
      units == "english" ? Unit.convert_from_kilometers_per_hour(kilometers_per_hour, Unit::MILES_PER_HOUR) : kilometers_per_hour
    end

    SQL = <<-EOS
      select
          timezone(timezones.tzid, start_time)::date as full_date
        , reporting.range_to_median(measurements.cadence) as cadence
        , reporting.range_to_median(measurements.calories) as calories
        , reporting.range_to_median(measurements.distance) as distance
        , reporting.range_to_median(measurements.duration) as duration
        , reporting.range_to_median(measurements.heart_rate) as heart_rate
        , reporting.range_to_median(measurements.incline) as incline
        , reporting.range_to_median(measurements.level) as level
        , reporting.range_to_median(measurements.repetitions) as repetitions
        , reporting.range_to_median(measurements.resistance) as resistance
        , reporting.range_to_median(measurements.speed) as speed
      from work
        join users using(user_id)
        join activities using(activity_id)
        join measurements using(measurement_id)
        join cities using(city_id)
        join timezones on st_within(cities.the_geom, timezones.the_geom)
      where
        login = :login and activities.name = :activity_name
        and start_time between :start_date and :end_date
      order by start_time;
    EOS

    def self.find_by_user_date_and_activity(user, activity, start_date = Date.parse("2013-01-01"), end_date = DateTime.now.utc)
      self.find_by_sql([SQL,  { :login => user.login, :activity_name => activity.name,
                                :start_date => start_date, :end_date => end_date}])
    end


  end
end