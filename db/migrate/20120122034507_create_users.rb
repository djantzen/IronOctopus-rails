class CreateUsers < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.users (
        user_id serial primary key,
        login text not null,
        email text not null,
        password text not null,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      create unique index users_uniq_idx_login on application.users (lower(login));
      create unique index users_uniq_idx_email on application.users (lower(email));

      grant select on application.users to reporter;
      grant delete, insert, select, update on application.users to application;
      grant usage on application.users_user_id_seq to application;
      
      comment on table application.users is 'All users in the systems.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.users;
    OES
  end
  
  
end
