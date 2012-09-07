class CreateLicenses < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.licenses (
        license_id serial primary key,
        license_uuid uuid not null,
        trainer_id integer not null references application.users(user_id) deferrable,
        client_id integer not null references application.users(user_id) deferrable,
        status text not null default 'new' check(status in('new', 'pending', 'assigned')),
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.licenses to reader;
      grant delete, insert, update on application.licenses to writer;
      grant select, update, usage on application.licenses_license_id_seq to writer;

      create unique index on application.licenses (trainer_id, client_id) where trainer_id != client_id;

      comment on table application.licenses is 'A table recording all seat licenses in the system';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.licenses;
    OES
  end
end