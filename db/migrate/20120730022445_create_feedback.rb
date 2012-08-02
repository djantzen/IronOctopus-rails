class CreateFeedback < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.feedback (
        feedback_id serial primary key,
        user_id integer not null references application.users(user_id) deferrable,
        remarks text not null,
        score integer not null default 0 check (score between -5 and 5),
        hidden boolean not null default false,
        created_at timestamptz not null default now()
      );

      grant select on application.feedback to reader;
      grant delete, insert, update on application.feedback to writer;

      grant select, usage, update on application.feedback_feedback_id_seq to writer;

      comment on table application.feedback is 'A table of user generated feedback';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.feedback;
    OES
  end

end
