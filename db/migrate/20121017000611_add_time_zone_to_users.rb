class AddTimeZoneToUsers < ActiveRecord::Migration
  def self.up
    execute <<-OES
      alter table application.users add column time_zone text not null default 'America/Los_Angeles';
    OES
  end

  def self.down
    execute <<-OES
      alter table application.users drop column time_zone;
    OES
  end
end
