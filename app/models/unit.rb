class Unit < ActiveRecord::Base
  has_many :resistance_measurements, :class_name => 'Measurement', :foreign_key => 'resistance_unit_id'
  has_many :distance_measurements, :class_name => 'Measurement', :foreign_key => 'distance_unit_id'
  has_many :pace_measurements, :class_name => 'Measurement', :foreign_key => 'pace_unit_id'
end
