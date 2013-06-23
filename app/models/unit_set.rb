class UnitSet < ActiveRecord::Base

  has_many :routines, :through => :activity_sets
  belongs_to :cadence_unit, :class_name => 'Unit', :foreign_key => 'cadence_unit_id', :readonly => true
  belongs_to :distance_unit, :class_name => 'Unit', :foreign_key => 'distance_unit_id', :readonly => true
  belongs_to :duration_unit, :class_name => 'Unit', :foreign_key => 'duration_unit_id', :readonly => true
  belongs_to :resistance_unit, :class_name => 'Unit', :foreign_key => 'resistance_unit_id', :readonly => true
  belongs_to :speed_unit, :class_name => 'Unit', :foreign_key => 'speed_unit_id', :readonly => true

  DEFAULTS = { :cadence_unit => Unit::NONE, :distance_unit => Unit::NONE, :duration_unit => Unit::NONE,
               :resistance_unit => Unit::NONE, :speed_unit => Unit::NONE }
    
  def self.find_or_create(unit_set_hash)
    # When we look up a measurement, be sure to get the one with the attributes we care about
    # AND the defaults, not just the first to match desired attributes.
    conditions = {}
    unit_set_hash.each do |key, value|
      key_id = (key.to_s + '_id').to_sym
      raise(ArgumentError, "Unknown Unit attribute #{key}") unless DEFAULTS.has_key?(key)
      if value.nil?
        conditions[:key_id] = DEFAULTS[key].unit_id
      else
        conditions[key_id] = unit_set_hash[key].unit_id
      end
    end
    
    unit_set = UnitSet.first(:conditions => conditions)
    if unit_set.nil?
      unit_set = UnitSet.new(conditions)
      unit_set.save
    end
    unit_set
  end
  
end
