class CreateInvitations < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.invitations (
        invitation_id serial primary key,
        invitation_uuid uuid not null,
        trainer_id integer not null references application.users(user_id) deferrable,
        license_id integer not null references application.licenses(license_id) deferrable,
        email_to text not null,
        accepted boolean not null default false,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.invitations to reader;
      grant delete, insert, update on application.invitations to writer;
      grant select, update, usage on application.invitations_invitation_id_seq to writer;

      create unique index on application.invitations (license_id);
      create unique index on application.invitations (trainer_id, email_to);

      comment on table application.invitations is 'A table mapping licenses, trainers and email invitations.';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.invitations;
    OES
  end
end