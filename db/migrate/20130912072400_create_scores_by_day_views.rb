class CreateScoresByDayViews < ActiveRecord::Migration
  def up
    execute <<-EOS
      create function reporting.score_metric(prescribed numrange, actual numrange) returns integer as $$
        select case
          when prescribed = '[0,0]' then 0
          when actual = prescribed then 1
          when actual > prescribed then 2
          when actual < prescribed then -1
        end
      $$ language 'sql';

      create function reporting.score_metric(prescribed int4range, actual int4range) returns integer as $$
        select case
          when prescribed = '[0,1)' then 0
          when actual = prescribed then 1
          when actual > prescribed then 2
          when actual < prescribed then -1
        end
      $$ language 'sql';

      create view reporting.measurement_scores as
        select
          measurement_id,
          case when cadence = '[0,0]' then 0 else 1 end +
          case when calories = '[0,1)' then 0 else 1 end +
          case when distance = '[0,0]' then 0 else 1 end +
          case when duration = '[0,1)' then 0 else 1 end +
          case when heart_rate = '[0,1)' then 0 else 1 end +
          case when incline = '[0,0]' then 0 else 1 end +
          case when level = '[0,1)' then 0 else 1 end +
          case when repetitions = '[0,1)' then 0 else 1 end +
          case when resistance = '[0,0]' then 0 else 1 end +
          case when speed = '[0,0]' then 0 else 1 end
          as measurement_score
        from measurements;
      grant select on reporting.measurement_scores to reader;

      create view reporting.routine_scores as
        select routine_id, routines.name as routine_name, sum(measurement_score * sets) as routine_score from routines
          join activity_set_groups using (routine_id)
          join activity_sets using(activity_set_group_id)
          join measurement_scores using(measurement_id)
        group by routine_id, routines.name;
        grant select on reporting.routine_scores to reader;

      create view reporting.work_scores as
        select routine_id, routine_name, client_login, day_id, full_date, sum(work_score) as work_score from
          (select routine_id, routines.name as routine_name, day_id, full_date, users.login as client_login,
            score_metric(prescribed.cadence, actual.cadence) +
              score_metric(prescribed.calories, actual.calories) +
              score_metric(prescribed.distance, actual.distance) +
              score_metric(prescribed.duration, actual.duration) +
              score_metric(prescribed.incline, actual.incline) +
              score_metric(prescribed.level, actual.level) +
              score_metric(prescribed.repetitions, actual.repetitions) +
              score_metric(prescribed.resistance, actual.resistance) +
              score_metric(prescribed.speed, actual.speed) +
              score_metric(prescribed.heart_rate, actual.heart_rate) as work_score
        from reporting.work
          join measurements prescribed on prescribed_measurement_id = prescribed.measurement_id
          join measurements actual on work.measurement_id = actual.measurement_id
          join routines using(routine_id)
          join users using(user_id)
          join days using(day_id)
        ) records
        group by routine_id, routine_name, client_login, day_id, full_date;
      grant select on reporting.work_scores to reader;

      create view reporting.routines_by_day as
        select
          routine_id, routine_name, login as client_login, full_date, routine_score
        from application.routines
          join application.scheduled_programs using(routine_id)
          join days on scheduled_on = full_date
          join users on client_id = user_id
          join routine_scores using(routine_id)
        group by routine_id, routine_name, full_date, routine_score, client_login
        union
        select
          routine_id, routine_name, login as client_login, full_date, routine_score
        from application.routines
          join application.weekday_programs using(routine_id)
          join routine_scores using(routine_id)
          join days using(day_of_week)
          join users on client_id = user_id
        group by routine_id, routine_name, full_date, routine_score, client_login
        order by full_date;
        grant select on reporting.routines_by_day to reader;
    EOS
  end

  def down
    execute <<-EOS
      drop view routines_by_day;
      drop view reporting.work_scores;
      drop view reporting.routine_scores;
      drop view reporting.measurement_scores;
      drop function reporting.score_metric(int4range, int4range);
      drop function reporting.score_metric(numrange, numrange);
    EOS
  end
end
