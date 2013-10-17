class ActivityImage < ActiveRecord::Base
  belongs_to :activity
  mount_uploader :image, ImageUploader
  has_one :activity_image_origin
  attr_accessible :remote_image_url, :remove_image

  def to_param
    activity.to_param
  end
end