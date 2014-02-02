class CreateRecurringAppointmentsView < ActiveRecord::Migration
  def up
    execute <<-EOS
      create view application.recurring_appointments as
      select
          trainer_id
        , client_id
        , tstzrange((full_date + lower(time_slot)) at time zone tz.tzid,
                    (full_date + upper(time_slot)) at time zone tz.tzid) as date_time_slot
      from recurring_appointment_rules
        join reporting.days using(day_of_week)
        join users u on client_id = u.user_id
        join cities c using(city_id)
        join timezones tz on (st_within(c.the_geom, tz.the_geom))
      order by full_date + lower(time_slot);

      grant select on application.recurring_appointments to reader;
      comment on view application.recurring_appointments is 'Maps the day of week and time slot directives of recurring appointments to actual timestamp ranges';
    EOS
  end

  def down
    execute <<-EOS
      drop view application.recurring_appointments;
    EOS
  end
end
