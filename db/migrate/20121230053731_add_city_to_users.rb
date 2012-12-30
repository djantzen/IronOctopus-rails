class AddCityToUsers < ActiveRecord::Migration
  def self.up
    execute <<-OES
      alter table application.users add column city_id integer not null default 685 references application.cities deferrable;
    OES
  end

  def self.down
    execute <<-OES
      alter table application.users drop column city_id;
    OES
  end
end
