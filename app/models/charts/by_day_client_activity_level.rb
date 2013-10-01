module Charts
  class ByDayClientActivityLevel < Day

    def client_name
      "#{attributes["first_name"]} #{attributes['last_name']}"
    end

    def client_login
      attributes["client_login"]
    end

    def score
      attributes["score"]
    end

    PRESCRIBED_SCORE_SQL = <<-EOS
      with clients as
        (select clients.login, clients.first_name, clients.last_name from users trainers
          join user_relationships on trainers.user_id = user_relationships.trainer_id
          join users clients on user_relationships.client_id = clients.user_id
          where trainers.login = :trainer_login)
      select
          routine_scores_by_day.client_login
        , clients.first_name
        , clients.last_name
        , sum(coalesce(routine_score, 0)) as score
      from clients, routine_scores_by_day
      where clients.login = routine_scores_by_day.client_login and routine_scores_by_day.full_date between :start_date and :end_date
      group by routine_scores_by_day.client_login, clients.first_name, clients.last_name
      order by clients.first_name, clients.last_name;
    EOS

    ACTUAL_SCORE_SQL = <<-EOS
      with clients as
        (select clients.login, clients.first_name, clients.last_name from users trainers
          join user_relationships on trainers.user_id = user_relationships.trainer_id
          join users clients on user_relationships.client_id = clients.user_id
        where trainers.login = :trainer_login)
      select
          work_scores_by_day.client_login
        , clients.first_name
        , clients.last_name
        , sum(coalesce(work_score, 0)) as score
      from clients, work_scores_by_day
      where clients.login = work_scores_by_day.client_login and work_scores_by_day.full_date between :start_date and :end_date
      group by work_scores_by_day.client_login, clients.first_name, clients.last_name
      order by clients.first_name, clients.last_name;
    EOS

    def self.get_activity_levels(trainer, start_date, end_date)
      search_params = { :trainer_login => trainer.login, :start_date => start_date, :end_date => end_date}
      prescribed_scores = self.find_by_sql([PRESCRIBED_SCORE_SQL, search_params])
      actual_scores = self.find_by_sql([ACTUAL_SCORE_SQL, search_params])

      prescribed_scores.each do |p_score|

        a_score = actual_scores.select { |temp_a_score|
          temp_a_score.client_login = p_score.client_login
        }.first

        p_score.score = a_score.score.to_i - p_score.score.to_i
      end
      prescribed_scores
    end

    def to_s
      attributes["client_login"]
    end
  end

end
