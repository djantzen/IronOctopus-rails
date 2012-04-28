class CreateUserRelationships < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.user_relationships (
        trainer_id integer not null references application.users deferrable,
        client_id integer not null references application.users deferrable,
        created_at timestamptz not null default now(),
        primary key (trainer_id, client_id)
      );

      grant select on application.user_relationships to reader;
      grant delete, insert, update on application.user_relationships to writer;

      comment on table application.user_relationships is 'A table to construct the graph of user relationships';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.user_relationships;
    OES
  end
  
  
end
