class CreateActivityImages < ActiveRecord::Migration
  def up
    execute <<-EOS
      create table application.activity_images (
        activity_image_id serial primary key,
        activity_id integer not null references application.activities(activity_id) deferrable,
        image text not null default '',
        position integer not null default 1,
        created_at timestamptz not null default now()
      );
      grant select on application.activity_images to reader;
      grant delete, insert, update on application.activity_images to writer;

      create index on application.activity_images(activity_id);
      create unique index on application.activity_images(activity_id, image);
      grant select, usage, update on application.activity_images_activity_image_id_seq to writer;

      comment on table application.activity_images is 'Associated image filenames for activities.';
    EOS
  end

  def down
    execute <<-EOS
      drop table application.activity_images;
    EOS
  end
end
