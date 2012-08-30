class Measurement < ActiveRecord::Base

  has_many :routines, :through => :activity_sets
  
  DEFAULTS = { :cadence => 0.0, :calories => 0, :distance => 0.0, :duration => 0, :incline => 0.0,
               :level => 0, :resistance => 0.0, :speed => 0.0 }
    
  def self.find_or_create(measurement_hash)
    # When we look up a measurement, be sure to get the one with the attributes we care about
    # AND the defaults, not just the first to match desired attributes.
    
    measurement_hash.each do |key, value|
      raise(ArgumentError, "Unknown Measurement attribute #{key}") unless DEFAULTS.has_key?(key)
      if value.nil?
        measurement_hash[key] = DEFAULTS[key]
      end
    end
    
    measurement = Measurement.first(:conditions => DEFAULTS.merge(measurement_hash))
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
