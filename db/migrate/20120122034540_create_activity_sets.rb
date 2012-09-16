class CreateActivitySets < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.activity_sets (
        routine_id integer not null references application.routines deferrable,
        position integer not null default 1,
        activity_id integer not null references application.activities deferrable,
        measurement_id integer not null references application.measurements deferrable,
        unit_set_id integer not null references application.unit_sets deferrable,
        optional boolean not null default false,
        comments text not null default '',
        primary key (routine_id, position)
      );

      grant select on application.activity_sets to reader;
      grant delete, insert, update on application.activity_sets to writer;

      comment on table application.activity_sets is 'Maps routines, activities and activity sets to a user.';
      comment on column application.activity_sets.position is 'Represents a numeric position within a list.';

    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activity_sets;
    OES
  end
  
  
end
