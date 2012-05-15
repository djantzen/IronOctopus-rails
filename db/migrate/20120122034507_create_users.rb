class CreateUsers < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.users (
        user_id serial primary key,
        login text not null,
        first_name text not null,
        last_name text not null,
        email text not null,
        password_digest text not null,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      create unique index users_uniq_idx_login on application.users (lower(regexp_replace(login, '\s', '', 'g')));
      create unique index users_uniq_idx_email on application.users (lower(email));

      grant select on application.users to reader;
      grant delete, insert, update on application.users to writer;
      grant select, usage, update on application.users_user_id_seq to writer;
      
      comment on table application.users is 'All users in the system.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.users;
    OES
  end
  
  
end
