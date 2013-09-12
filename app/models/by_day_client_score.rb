# Pseudo model to encapsulate a reporting query showing prescribed and actual work over a date range for a client.
class ByDayClientScore < Day

  def prescribed_routine_client_login
    attributes["prescribed_routine_client_login"]
  end

  def prescribed_routine_name
    attributes["prescribed_routine_name"]
  end

  def routine_score
    attributes["routine_score"].to_i
  end

  def work_client_login
    attributes["work_client_login"]
  end

  def work_routine_name
    attributes["work_routine_name"]
  end

  def work_score
    attributes["work_score"].to_i
  end

  def total_prescribed_score
    attributes["total_prescribed_score"].to_i
  end

  def total_actual_score
    attributes["total_work_score"].to_i
  end

  SQL = <<-EOS
    select
        days.full_date
      , routines_by_day.client_login as prescribed_routine_client_login
      , routines_by_day.routine_name as prescribed_routine_name
      , coalesce(routine_score, 0) as routine_score
      , work_scores.client_login as work_client_login
      , work_scores.routine_name as work_routine_name
      , coalesce(work_score, 0) as work_score
      , sum(routine_score) over (partition by coalesce(routines_by_day.client_login, :login) order by days.full_date) as total_prescribed_score
      , sum(work_score) over (partition by coalesce(work_scores.client_login, :login) order by days.full_date) as total_work_score
    from reporting.days
      left join routines_by_day on days.full_date = routines_by_day.full_date and routines_by_day.client_login = :login
      left join work_scores on days.full_date = work_scores.full_date and work_scores.client_login = :login
    where days.full_date between :start_date and :end_date
    order by days.full_date;
  EOS

  def self.find_by_user_and_dates(user, start_date, end_date)
    self.find_by_sql([SQL, { :login => user.login, :start_date => start_date, :end_date => end_date}])
  end

end