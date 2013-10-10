class ActivityImage < ActiveRecord::Base
  belongs_to :activity
  mount_uploader :image, ImageUploader
  has_one :activity_image_origin
  attr_accessible :remote_image_url
end