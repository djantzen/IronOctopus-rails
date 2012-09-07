class Work < ActiveRecord::Base
  
  belongs_to :routine
  belongs_to :user
  belongs_to :activity
  belongs_to :measurement
  belongs_to :start_day, :class_name => 'Day', :foreign_key => 'start_day_id'
end
