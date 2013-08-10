class ActivitySet < ActiveRecord::Base

  belongs_to :activity
  belongs_to :measurement
  belongs_to :routine
  belongs_to :unit_set
  belongs_to :activity_set_group

  def to_s
    "#{activity.name} in #{routine}"
  end
end
