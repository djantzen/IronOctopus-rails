class CreateActivityAttributes < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.activity_attributes (
        activity_attribute_id serial primary key,
        name text not null,
        permalink text not null,
        created_at timestamptz not null default now()
      );

      create unique index on application.activity_attributes(permalink);

      grant select on application.activity_attributes to reader;
      grant delete, insert, update on application.activity_attributes to writer;
      grant select, usage, update on application.activity_attributes_activity_attribute_id_seq to writer;

      comment on table application.activity_attributes is 'A table of user generated attributes';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.activity_attributes;
    OES
  end

end
