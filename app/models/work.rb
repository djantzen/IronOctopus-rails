class Work < ActiveRecord::Base
  
  belongs_to :routine
  belongs_to :user
  belongs_to :activity
  belongs_to :measurement
  belongs_to :prescribed_measurement, :class_name => "Measurement", :foreign_key => "prescribed_measurement_id"
  belongs_to :day
  belongs_to :unit_set

  before_save { self.start_time = self.start_time.utc }

  def to_s
    "#{activity.name} in routine #{routine.name} on #{day} "
  end
end
