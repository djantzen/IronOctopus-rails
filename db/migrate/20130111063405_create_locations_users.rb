class CreateLocationsUsers < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.locations_users (
        location_id integer not null references application.locations deferrable,
        user_id integer not null references application.users deferrable,
        primary key (location_id, user_id)
      );

      grant select on application.locations_users to reader;
      grant delete, insert, update on application.locations_users to writer;

      comment on table application.locations_users is 'A table mapping users to locations';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.locations_users;
    OES
  end
end
