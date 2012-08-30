class CreateActivityTypes < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.activity_types (
        activity_type_id serial primary key,
        name text not null
      );
      
      create unique index activity_types_uniq_idx_name on application.activity_types (name);
      
      grant select on application.activity_types to reader;

      comment on table application.activity_types is 'Organizes activities into categories like ''Cardiovascular'', ''Resistance'', ''Plyometric''';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activity_types;
    OES
  end

end
