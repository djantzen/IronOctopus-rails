class CreateActivityVideos < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.activity_videos (
        activity_video_id serial primary key,
        activity_id integer not null references application.activities(activity_id) deferrable,
        video_uri text not null default '',
        position integer not null default 1,
        created_at timestamptz not null default now()
      );
      grant select on application.activity_videos to reader;
      grant delete, insert, update on application.activity_videos to writer;

      create index on application.activity_videos(activity_id);
      grant select, usage, update on application.activity_videos_activity_video_id_seq to writer;

      comment on table application.activity_videos is 'A table with URIs for activity videos.';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.activity_videos;
    OES
  end
end
