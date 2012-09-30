class CreateActivityTypes < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.activity_types (
        activity_type_id serial primary key,
        name text not null
      );
      
      create unique index on application.activity_types (name);
      
      grant select on application.activity_types to reader;
      grant delete, insert, update on application.activity_types to writer;
      grant select, update, usage on application.activity_types_activity_type_id_seq to writer;

      comment on table application.activity_types is 'Organizes activities into categories like ''Cardiovascular'', ''Resistance'', ''Plyometric''';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activity_types;
    OES
  end

end
