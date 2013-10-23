class AddDefinitionToActivityAttributes < ActiveRecord::Migration

  def self.up
    execute <<-EOS
      alter table application.activity_attributes add column definition text not null default '';
    EOS
  end
  def self.down
    execute <<-EOS
      alter table application.activity_attributes drop column definition;
    EOS
  end
end
