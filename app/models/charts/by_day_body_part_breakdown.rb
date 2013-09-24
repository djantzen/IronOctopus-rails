module Charts

  # Pseudo model to encapsulate a reporting query showing breakdown of activity frequency by anatomy
  class ByDayBodyPartBreakdown < Day

    def body_region
      attributes["body_region"]
    end

    def count
      attributes["count"].to_i
    end

    SQL = <<-EOS
      select body_parts.region as body_region, count(1) as count
      from days
        join work using(day_id)
        join users using(user_id)
        join activities using(activity_id)
        join activities_body_parts using(activity_id)
        join body_parts using(body_part_id)
      where login = :login and full_date between :start_date and :end_date
      group by login, body_parts.region;
    EOS

    def self.find_by_user_and_dates(user, start_date, end_date)
      self.find_by_sql([SQL, { :login => user.login, :start_date => start_date, :end_date => end_date}])
    end

  end
end
