class CreateActivitiesMetrics < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.activities_metrics (
        activity_id integer not null references application.activities deferrable,
        metric_id integer not null references application.metrics deferrable,
        created_at timestamptz not null default now(),
        primary key(activity_id, metric_id)
      );
      grant select on application.activities_metrics to reader;
      grant insert, update, delete on application.activities_metrics to writer;

      comment on table application.activities_metrics is 'Mapping table to associate metrics to activities.';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.activities_metrics;
    OES
  end

end
