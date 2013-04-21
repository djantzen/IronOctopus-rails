class ActivityVideo < ActiveRecord::Base

  belongs_to :activity

  def to_s
    video_uri
  end
end
