class AddRestIntervalToActivitySetGroups < ActiveRecord::Migration
  def self.up
    execute <<-EOS
      alter table application.activity_set_groups add column rest_interval integer not null default 0;
      comment on column application.activity_set_groups.rest_interval is 'Seconds of rest between sets';
    EOS
  end
  def self.down
    execute <<-EOS
      alter table application.activity_set_groups drop column rest_interval;
    EOS
  end
end
