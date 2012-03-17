class Measurement < ActiveRecord::Base

  has_many :routines, :through => :activity_sets
  belongs_to :distance_unit, :class_name => 'Unit', :foreign_key => 'distance_unit_id'
  belongs_to :pace_unit, :class_name => 'Unit', :foreign_key => 'pace_unit_id'
  belongs_to :resistance_unit, :class_name => 'Unit', :foreign_key => 'resistance_unit_id'
  
  def self.lookup_hash
    self.columns.inject({}) do |hash, col|
      hash[col.name.to_sym] = col.default unless col.name.eql?('measurement_id') || col.name.eql?('created_at')
      hash
    end
  end
  
  def self.find_or_create(measurement_key)
    # When we look up a measurement, be sure to get the one with the attributes we care about
    # AND the defaults, not just the first to match desired attributes.
    key_plus_defaults = lookup_hash.merge(measurement_key)
    
    measurement = Measurement.find(:first, :conditions => key_plus_defaults)
    if measurement.nil?
      measurement = Measurement.new(measurement_key)
      measurement.save
    end
    measurement
  end
  
  # generates separate selects, do custom validation
#  validates_uniqueness_of :activity_id, :duration, :resistance, :repetitions, :pace, :distance,
#    :calories, :distance_unit_id, :resistance_unit_id, :pace_unit_id
end
