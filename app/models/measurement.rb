class Measurement < ActiveRecord::Base

  has_many :routines, :through => :activity_sets
  belongs_to :distance_unit, :class_name => 'Unit', :foreign_key => 'distance_unit_id'
  belongs_to :pace_unit, :class_name => 'Unit', :foreign_key => 'pace_unit_id'
  belongs_to :resistance_unit, :class_name => 'Unit', :foreign_key => 'resistance_unit_id'
  
  # generates separate selects, do custom validation
#  validates_uniqueness_of :activity_id, :duration, :resistance, :repetitions, :pace, :distance,
#    :calories, :distance_unit_id, :resistance_unit_id, :pace_unit_id
end
