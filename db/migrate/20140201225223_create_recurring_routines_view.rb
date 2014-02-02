class CreateRecurringRoutinesView < ActiveRecord::Migration
  def up
    execute <<-EOS
      create view application.recurring_routines as
      select
          routine_id
        , tstzrange((full_date + lower(time_slot)) at time zone timezones.tzid,
                    (full_date + upper(time_slot)) at time zone timezones.tzid) as date_time_slot
      from recurring_routine_rules
        join routines using(routine_id)
        join reporting.days using(day_of_week)
        join users on routines.client_id = users.user_id
        join cities using(city_id)
        join timezones on (st_within(cities.the_geom, timezones.the_geom))
      order by full_date + lower(time_slot);

      grant select on application.recurring_routines to reader;
      comment on view application.recurring_routines is 'Maps the day of week and time slot directives of recurring routines to actual timestamp ranges';
    EOS
  end

  def down
    execute <<-EOS
      drop view application.recurring_routines;
    EOS
  end
end
