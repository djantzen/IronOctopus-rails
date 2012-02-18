class CreateActivitySets < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.activity_sets (
        routine_id integer not null references application.routines,
        activity_id integer not null references application.activities,
        measurement_id integer not null references application.measurements,
        position real not null default 1,
        optional boolean not null default false,
        primary key (routine_id, activity_id, measurement_id, position)
      );
      
      create unique index activity_sets_uniq_idx_routine_id_position on application.activity_sets
        (routine_id, position);

      grant select on application.activity_sets to reporter;
      grant delete, insert, select, update on application.activity_sets to application;

      comment on table application.activity_sets is 'Maps routines, activities and activity sets to a user.';
      comment on column application.activity_sets.position is
        'Represents a numeric position within a hierarchy similar to outline numbering.';

    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activity_sets;
    OES
  end
  
  
end
