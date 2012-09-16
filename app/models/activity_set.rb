class ActivitySet < ActiveRecord::Base

  belongs_to :activity
  belongs_to :measurement
  belongs_to :routine
  belongs_to :unit_set

end
