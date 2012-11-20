class CreatePasswordResetRequests < ActiveRecord::Migration


  def self.up
    execute <<-OES
      create table application.password_reset_requests (
        password_reset_request_id serial primary key,
        user_id integer not null references application.users(user_id) deferrable,
        email_to text not null,
        password_reset_request_uuid uuid not null,
        password_reset boolean not null default false,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.password_reset_requests to reader;
      grant delete, insert, update on application.password_reset_requests to writer;
      grant select, update, usage on application.password_reset_requests_password_reset_request_id_seq to writer;

      comment on table application.password_reset_requests is 'A table storing requests to reset a user password';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.password_reset_requests;
    OES
  end

end
