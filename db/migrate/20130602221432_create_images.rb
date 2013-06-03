class CreateImages < ActiveRecord::Migration
  def up
    execute <<-OES
      alter table application.body_parts add column image text not null default 'image_not_found.jpg';
      alter table application.implements add column image text not null default 'image_not_found.jpg';
      alter table application.profiles add column image text not null default 'image_not_found.jpg';
    OES
  end

  def down
    execute <<-OES
      alter table application.body_parts drop column image;
      alter table application.implements drop column image;
      alter table application.profiles drop column image;
    OES
  end
end
