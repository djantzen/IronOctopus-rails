class CreateProfiles < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.profiles (
        user_id integer primary key not null references application.users deferrable,
        creative text not null default '',
        education text not null default '',
        email text not null default '',
        phone text not null default '',
        gender text not null default 'Male' check(gender in('Female', 'Male')),
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.profiles to reader;
      grant delete, insert, update on application.profiles to writer;

      comment on table application.profiles is 'A table of trainer advertising page information';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.profiles;
    OES
  end
end
