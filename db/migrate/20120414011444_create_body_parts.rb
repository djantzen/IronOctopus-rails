class CreateBodyParts < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.body_parts (
        body_part_id serial primary key,
        formal_name text not null,
        region text not null,
        permalink text not null,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.body_parts to reader;
      grant delete, insert, update on application.body_parts to writer;
      grant select, update, usage on application.body_parts_body_part_id_seq to writer;

      create unique index on application.body_parts (permalink);

      comment on table application.body_parts is 'A reference table of basic human physiology.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.body_parts;
    OES
  end
end