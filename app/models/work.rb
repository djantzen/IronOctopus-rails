class Work < ActiveRecord::Base
  
  belongs_to :routine
  belongs_to :user
  belongs_to :activity
  belongs_to :measurement
  belongs_to :start_day, :class_name => 'Day', :foreign_key => 'start_day_id'
  belongs_to :cadence_unit, :class_name => 'Unit', :foreign_key => 'cadence_unit_id'
  belongs_to :distance_unit, :class_name => 'Unit', :foreign_key => 'distance_unit_id'
  belongs_to :duration_unit, :class_name => 'Unit', :foreign_key => 'duration_unit_id'
  belongs_to :resistance_unit, :class_name => 'Unit', :foreign_key => 'resistance_unit_id'
  belongs_to :speed_unit, :class_name => 'Unit', :foreign_key => 'speed_unit_id'
end
