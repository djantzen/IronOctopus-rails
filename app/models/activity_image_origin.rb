class ActivityImageOrigin < ActiveRecord::Base
  belongs_to :activity_image
  validates :origin_url, :url => true
end