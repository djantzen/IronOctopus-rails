class CreateActions < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table reporting.actions (
        user_id integer not null references application.users,
        controller_id integer not null references reporting.controllers,
        action_name text not null,
        device_id integer not null references application.devices,
        day_id integer not null references reporting.days,
        occurred_at timestamptz not null,
      );
      comment on table reporting.actions is 'A running log of all user-initiated actions in the application.';
      grant select on reporting.actions to reporter;
      grant insert, select on reporting.actions to application;
    OES
  end
  
  def self.down
    execute <<-OES
      drop table reporting.actions;
    OES
  end
  
  
end
