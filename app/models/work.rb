class Work < ActiveRecord::Base
  
  belongs_to :routine
  belongs_to :user
  belongs_to :activity
  belongs_to :measurement
  belongs_to :start_day, :class_name => 'Day', :foreign_key => 'start_day_id'
  belongs_to :unit_set

  before_save { self.start_time = self.start_time.utc }
  before_save { self.end_time = self.end_time.utc }

end
