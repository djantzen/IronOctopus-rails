class TodaysRoutinesUpdated < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create or replace view application.todays_routines as
        select r.client_id, r.routine_id
        from application.users u
          join application.routines r on u.user_id = r.client_id
          join application.scheduled_programs sp on r.routine_id = sp.routine_id
          join cities c on u.city_id = c.city_id
          join timezones tz on (st_within(c.the_geom, tz.the_geom))
        where sp.scheduled_on = (now() at time zone tz.tzid)::date
        union
        select r.client_id, r.routine_id
        from application.users u
          join application.routines r on u.user_id = r.client_id
          join application.weekday_programs wp on r.routine_id = wp.routine_id
          join cities c on u.city_id = c.city_id
          join timezones tz on (st_within(c.the_geom, tz.the_geom))
        where wp.day_of_week = trim(to_char(now() at time zone tz.tzid, 'Day'));
    OES
  end

  def self.down
    execute <<-OES
      create or replace view application.todays_routines as
        select r.client_id, r.routine_id
        from application.users u
          join application.routines r on u.user_id = r.client_id
          join application.scheduled_programs sp on r.routine_id = sp.routine_id
        where sp.scheduled_on = (now() at time zone u.time_zone)::date
        union
        select r.client_id, r.routine_id
        from application.users u
          join application.routines r on u.user_id = r.client_id
          join application.weekday_programs wp on r.routine_id = wp.routine_id
        where wp.day_of_week = trim(to_char(now() at time zone u.time_zone, 'Day'));
    OES
  end

end
