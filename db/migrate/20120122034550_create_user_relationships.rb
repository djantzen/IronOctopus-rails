class CreateUserRelationships < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.user_relationships (
        teacher_id integer not null references application.users deferrable,
        student_id integer not null references application.users deferrable,
        created_at timestamptz not null default now(),
        primary key (teacher_id, student_id)
      );

      grant select on application.user_relationships to reporter;
      grant delete, insert, select, update on application.user_relationships to application;

      comment on table application.user_relationships is 'A table to construct the graph of user relationships';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.user_relationships;
    OES
  end
  
  
end
