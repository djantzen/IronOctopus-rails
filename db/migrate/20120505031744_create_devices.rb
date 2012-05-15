class CreateDevices < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.devices (
        device_id serial primary key,
        device_uuid uuid not null,
        user_id integer not null references application.users(user_id) deferrable,
        created_at timestamptz not null default now()
      );

      grant select on application.devices to reader;
      grant delete, insert, update on application.devices to writer;
      
      grant select, usage, update on application.devices_device_id_seq to writer;

      comment on table application.devices is 'A table of registered mobile devices';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.devices;
    OES
  end
end
