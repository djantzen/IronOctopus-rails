module Charts
  class ByDayActivityMeasurements < Day

    def full_date
      attributes["full_date"]
    end

    def cadence
      attributes["cadence"].to_i
    end

    def calories
      attributes["calories"].to_i
    end

    def distance
      attributes["distance"].to_f
    end

    def duration
      attributes["duration"].to_i
    end

    def heartrate
      attributes["heart_rate"].to_i
    end

    def incline
      attributes["incline"].to_i
    end

    def level
      attributes["level"].to_i
    end

    def repetitions
      attributes["repetitions"].to_i
    end

    def resistance
      attributes["resistance"].to_f
    end

    def speed
      attributes["speed"].to_f
    end

    SQL = <<-EOS
      select
          full_date
        , reporting.range_to_median(measurements.cadence) as cadence
        , reporting.range_to_median(measurements.calories) as calories
        , reporting.range_to_median(measurements.distance) / 1000 as distance
        , reporting.range_to_median(measurements.duration) as duration
        , reporting.range_to_median(measurements.heart_rate) as heart_rate
        , reporting.range_to_median(measurements.incline) as incline
        , reporting.range_to_median(measurements.level) as level
        , reporting.range_to_median(measurements.repetitions) as repetitions
        , reporting.range_to_median(measurements.resistance) as resistance
        , reporting.range_to_median(measurements.speed) as speed
      from days
        join work using(day_id)
        join users using(user_id)
        join activities using(activity_id)
        join measurements using(measurement_id)
      where login = :login and activities.name = :activity_name
      and full_date between :start_date and :end_date
      order by full_date;
    EOS

    def self.find_by_user_date_and_activity(user, activity, start_date = Date.parse("2012-01-01"), end_date = DateTime.now.utc.to_date)
      self.find_by_sql([SQL,  { :login => user.login, :activity_name => activity.name,
                                :start_date => start_date, :end_date => end_date}])
    end


  end
end