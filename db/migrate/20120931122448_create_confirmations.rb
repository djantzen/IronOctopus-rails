class CreateConfirmations < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.confirmations (
        user_id integer not null primary key references application.users(user_id) deferrable,
        confirmation_uuid uuid not null,
        confirmed boolean not null default false,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.confirmations to reader;
      grant delete, insert, update on application.confirmations to writer;

      comment on table application.confirmations is 'A table storing confirmation email statuses.';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.confirmations;
    OES
  end
end
