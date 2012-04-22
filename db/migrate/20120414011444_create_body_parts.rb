class CreateBodyParts < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.body_parts (
        body_part_id serial primary key,
        formal_name text not null,
        common_name text not null,
        role text not null default 'Not yet specified',
        category text not null default 'Muscle',
        region text not null,
        creator_id integer not null references application.users(user_id) deferrable,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.body_parts to reporter;
      grant delete, insert, select, update on application.body_parts to application;
      grant select, update, usage on application.body_parts_body_part_id_seq to application;

      create unique index body_parts_uniq_idx_name on application.body_parts (lower(regexp_replace(formal_name, '\s', 'g')));

      comment on table application.body_parts is 'A reference table of basic human physiology.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.body_parts;
    OES
  end
end