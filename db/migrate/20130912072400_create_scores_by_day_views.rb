class CreateScoresByDayViews < ActiveRecord::Migration
  def up
    execute <<-EOS
      create function reporting.range_to_median(the_range numrange) returns numeric as $$
        select ((upper(the_range) - lower(the_range)) / 2) + lower(the_range);
      $$ language 'sql';
      comment on function reporting.range_to_median(numrange) is 'Returns the middle number (numeric) in the range';

      create function reporting.range_to_median(the_range int4range) returns numeric as $$
        select (((upper(the_range) - 1)::numeric - lower(the_range)::numeric) / 2) + lower(the_range);
      $$ language 'sql';
      comment on function reporting.range_to_median(int4range) is 'Returns the middle number (numeric) in the range';

      create view reporting.measurement_scores as
        select
          measurement_id,
          greatest(
            range_to_median(cadence) +
            + range_to_median(calories)
            + range_to_median(distance) / 100
            + range_to_median(duration) / 60
            + range_to_median(heart_rate)
            + range_to_median(incline) * 10
            + range_to_median(level) * 5
            + range_to_median(resistance)
            + range_to_median(speed) * 10, 1)
            * greatest(range_to_median(repetitions), 1) as measurement_score
        from measurements;
      grant select on reporting.measurement_scores to reader;
      comment on view reporting.measurement_scores is 'Calculates the score represented by an entire measurements record';

      create view reporting.routine_scores as
        select routine_id, routines.name as routine_name, sum(measurement_score * sets) as routine_score from routines
          join activity_set_groups using (routine_id)
          join activity_sets using(activity_set_group_id)
          join measurement_scores using(measurement_id)
        group by routine_id, routines.name;
      grant select on reporting.routine_scores to reader;
      comment on view reporting.routine_scores is 'Collects the measurement_scores for an entire routine and calculates and single score';

      create view reporting.work_scores_by_day as
        select
          routine_id, routines.name as routine_name, users.login as client_login, full_date, sum(measurement_score) as work_score
        from reporting.work
          join routines using(routine_id)
          join measurement_scores using(measurement_id)
          join users using(user_id)
          join days using(day_id)
        group by routine_id, routine_name, client_login, full_date;
      grant select on reporting.work_scores_by_day to reader;
      comment on view reporting.work_scores_by_day is 'Groups work records by routine, client and date and sums associated measurement_scores';

      create view reporting.routines_by_day as
        select
          login as client_login, routine_name, full_date, routine_score
        from application.routines
          join application.scheduled_programs using(routine_id)
          join days on scheduled_on = full_date
          join users on client_id = user_id
          join routine_scores using(routine_id)
        group by client_login, routine_name, full_date, routine_score
        union
        select
          login as client_login, routine_name, full_date, routine_score
        from application.routines
          join application.weekday_programs using(routine_id)
          join routine_scores using(routine_id)
          join days using(day_of_week)
          join users on client_id = user_id
        group by client_login, routine_name, full_date, routine_score
        order by full_date;
      grant select on reporting.routines_by_day to reader;
      comment on view reporting.routines_by_day is 'Groups routines by client and date and sums associated routine_scores';
    EOS
  end

  def down
    execute <<-EOS
      drop view reporting.routines_by_day;
      drop view reporting.work_scores_by_day;
      drop view reporting.routine_scores;
      drop view reporting.measurement_scores;

      drop function reporting.range_to_median(numrange);
      drop function reporting.range_to_median(int4range);
    EOS
  end
end
