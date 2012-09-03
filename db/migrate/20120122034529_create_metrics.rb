class CreateMetrics < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.metrics (
        metric_id serial primary key,
        name text not null
      );

      create unique index on application.metrics (name);

      grant select on application.metrics to reader;
      grant delete, insert, update on application.metrics to writer;
      grant select, update, usage on application.metrics_metric_id_seq to writer;

      comment on table application.metrics is 'Measures such as resistance, duration associated with an activity set.';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.metrics;
    OES
  end

end
