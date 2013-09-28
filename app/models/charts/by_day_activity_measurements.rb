module Charts
  class ByDayActivityMeasurements < Day

    SQL = <<-EOS
      select
          full_date
        , reporting.range_to_number(measurements.cadence) as cadence
        , reporting.range_to_number(measurements.calories) as calories
        , reporting.range_to_number(measurements.distance) as distance
        , reporting.range_to_number(measurements.duration) as duration
        , reporting.range_to_number(measurements.heart_rate) as heart_rate
        , reporting.range_to_number(measurements.incline) as incline
        , reporting.range_to_number(measurements.level) as level
        , reporting.range_to_number(measurements.repetitions) as repetitions
        , reporting.range_to_number(measurements.resistance) as resistance
        , reporting.range_to_number(measurements.speed) as speed
      from days
        join work using(day_id)
        join users using(user_id)
        join activities using(activity_id)
        join measurements using(measurement_id)
      where login = :login and activities.name = :activity_name
      and full_date between :start_date and :end_date
      order by full_date;
    EOS

    def self.find_by_user_date_and_activity(user, activity, start_date = Date.today, end_date)
      self.find_by_sql([SQL,  { :login => user.login, :activity_name => activity.name,
                                :start_date => start_date, :end_date => end_date}])
    end


  end
end