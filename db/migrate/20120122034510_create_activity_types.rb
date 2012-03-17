class CreateActivityTypes < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.activity_types (
        activity_type_id serial primary key,
        name text not null
      );
      
      create unique index activity_types_uniq_idx_name on application.activity_types (name);
      
      grant delete, insert, select, update on application.activity_types to application;
      grant select on application.activity_types to reporter;
      grant select, update, usage on application.activity_types_activity_type_id_seq to application;
      comment on table application.activity_types is 'Organizes activities into categories like ''Cardiovascular'', ''Weight Training'', ''Plyometrics''';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activity_types;
    OES
  end

end
