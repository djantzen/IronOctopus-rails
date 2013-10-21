class AddDisplayOrderToBodyParts < ActiveRecord::Migration

  def self.up
    execute <<-EOS
      alter table application.body_parts add column display_order integer not null default 1;
    EOS
  end
  def self.down
    execute <<-EOS
      alter table application.body_parts drop column display_order;
    EOS
  end

end
