class CreateActionLog < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table reporting.action_log (
        user_id integer not null references application.users,
        controller_id integer not null references reporting.controllers,
        device_id integer not null references reporting.devices,
        date_id integer not null references reporting.dates,
        occurred_at timestamptz not null,
      );
      comment on table reporting.action_log is 'A running log of all user-initiated actions in the application.';
      grant select on reporting.users_routines to reporter;
      grant insert, select, update on reporting.users_routines to application;
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.users_routines;
    OES
  end
  
  
end
