class Measurement < ActiveRecord::Base

  has_many :routines, :through => :activity_sets
  belongs_to :distance_unit, :class_name => 'Unit', :foreign_key => 'distance_unit_id'
  belongs_to :pace_unit, :class_name => 'Unit', :foreign_key => 'pace_unit_id'
  belongs_to :resistance_unit, :class_name => 'Unit', :foreign_key => 'resistance_unit_id'
  
  DEFAULTS = { :duration => 0, :resistance => 0.0, :pace => 0.0, :distance => 0.0, :calories => 0,
               :distance_unit_id => 0, :resistance_unit_id => 0, :pace_unit_id => 0 }
    
  def self.find_or_create(measurement_hash)
    # When we look up a measurement, be sure to get the one with the attributes we care about
    # AND the defaults, not just the first to match desired attributes.
    
    measurement_hash.each do |key, value|
      raise raise(ArgumentError, "Unknown Measurement attribute #{key}") unless DEFAULTS.has_key?(key)
      if value.nil?
        measurement_hash[key] = DEFAULTS[key]
      end
    end
    
    measurement = Measurement.find(:first, :conditions => DEFAULTS.merge(measurement_hash))
    if measurement.nil?
      measurement = Measurement.new(measurement_hash)
      measurement.save
    end
    measurement
  end
  
  # generates separate selects, do custom validation
#  validates_uniqueness_of :activity_id, :duration, :resistance, :repetitions, :pace, :distance,
#    :calories, :distance_unit_id, :resistance_unit_id, :pace_unit_id
end
