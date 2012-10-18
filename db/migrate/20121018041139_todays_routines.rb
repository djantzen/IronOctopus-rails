class TodaysRoutines < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create view application.todays_routines as
        select r.client_id, r.routine_id
        from application.users u
          join application.routines r on u.user_id = r.client_id
          join application.scheduled_programs sp on r.routine_id = sp.routine_id
        where sp.scheduled_on = now()::date
        union
        select r.client_id, r.routine_id
        from application.users u
          join application.routines r on u.user_id = r.client_id
          join application.weekday_programs wp on r.routine_id = wp.routine_id
        where wp.day_of_week = trim(to_char(now(), 'Day'));

      grant select on application.todays_routines to reader, writer;

      comment on view application.todays_routines is 'A view describing the routines occurring today based on a program';
    OES
  end

  def self.down
    execute <<-OES
      drop view application.todays_routines;
    OES
  end

end
