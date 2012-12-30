class DropTimezoneFromUsers < ActiveRecord::Migration
  def up
    execute <<-OES
      alter table application.users drop column time_zone;
    OES
  end

  def down
    execute <<-OES
      alter table application.users add column time_zone text not null default 'America/Los_Angeles';
    OES
  end
end
