class CreateActivityCitations < ActiveRecord::Migration
  def up
    execute <<-EOS
      create table source.activity_citations (
        activity_citation_id serial primary key,
        activity_id integer not null references application.activities(activity_id) on delete cascade deferrable,
        citation_url text not null default '',
        created_at timestamptz not null default now()
      );
      grant select on source.activity_citations to reader;
      grant delete, insert, update on source.activity_citations to writer;

      create index on source.activity_citations(activity_id);
      grant select, usage, update on source.activity_citations_activity_citation_id_seq to writer;

      comment on table source.activity_citations is 'Associated citation urls for activities.';

      create table source.activity_image_origins (
        activity_image_origin_id serial primary key,
        activity_image_id integer not null references application.activity_images(activity_image_id) on delete cascade deferrable,
        origin_url text not null default '',
        created_at timestamptz not null default now()
      );
      grant select on source.activity_image_origins to reader;
      grant delete, insert, update on source.activity_image_origins to writer;

      create index on source.activity_image_origins(activity_image_id);
      grant select, usage, update on source.activity_image_origins_activity_image_origin_id_seq to writer;

      comment on table source.activity_image_origins is 'Associated origin urls for activity images.';
    EOS
  end

  def down
    execute <<-EOS
      drop table source.activity_citations;
      drop table source.activity_image_origins;
    EOS
  end
end
