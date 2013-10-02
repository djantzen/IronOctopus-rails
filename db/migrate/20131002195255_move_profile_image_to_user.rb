class MoveProfileImageToUser < ActiveRecord::Migration

  def up
    execute <<-OES
      alter table application.profiles drop column image;
      alter table application.users add column image text not null default 'image_not_found.jpg';
    OES
  end

  def down
    execute <<-OES
      alter table application.users drop column image;
      alter table application.profiles add column image text not null default 'image_not_found.jpg';
    OES
  end

end
