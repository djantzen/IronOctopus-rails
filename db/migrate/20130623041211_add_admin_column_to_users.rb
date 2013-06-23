class AddAdminColumnToUsers < ActiveRecord::Migration
  def self.up
    execute <<-OES
      alter table application.users add column is_admin boolean not null default false;
    OES
  end

  def self.down
    execute <<-OES
      alter table application.users drop column is_admin;
    OES
  end
end
