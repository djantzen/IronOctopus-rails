module Charts

  # Pseudo model to encapsulate a reporting query showing breakdown of activity frequency by type
  class ByDayActivityTypeBreakdown < Day

    def activity_type_name
      attributes["activity_type_name"]
    end

    def count
      attributes["count"].to_i
    end

    SQL = <<-EOS
      select activity_types.name as activity_type_name, count(1) as count
      from days
        join work using(day_id)
        join users using(user_id)
        join activities using(activity_id)
        join activity_types using(activity_type_id)
      where login = :login and full_date between :start_date and :end_date
      group by login, activity_types.name;
    EOS

    def self.find_by_user_and_dates(user, start_date, end_date)
      self.find_by_sql([SQL, { :login => user.login, :start_date => start_date, :end_date => end_date}])
    end

  end
end
