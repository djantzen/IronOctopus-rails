class Measurement < ActiveRecord::Base
  require "#{Rails.root.to_s}/lib/postgres_range_support"

  has_many :routines, :through => :activity_sets

  DEFAULTS = { :cadence => 0.0..0.0, :calories => 0..0, :distance => 0.0..0.0,
               :duration => 0..0, :heart_rate => 0..0, :incline => 0..0,
               :level => 0..0, :repetitions => 0..0, :resistance => 0.0..0.0,
               :speed => 0.0..0.0 }

  after_find :to_ranges # translate from database ranges
  after_save :to_ranges # repair the one in memory after save
  before_save :from_ranges # translate to database ranges

  def metrics
    Measurement.column_names - ["measurement_id", "created_at"]
  end

  def self.find_or_create(defined_metrics_map)
    # When we look up a measurement, be sure to get the one with the attributes we care about
    # AND the defaults, not just the first to match desired attributes.
    defined_metrics_map.each do |key, value|
      raise(ArgumentError, "Unknown Measurement attribute #{key}") unless DEFAULTS.has_key?(key)
      if value.nil?
        defined_metrics_map[key] = DEFAULTS[key]
      end
    end
    measurement_key = DEFAULTS.merge(defined_metrics_map)
    # translate from: resistance => 0.0 .. 0.0
    # to: resistance @> ['0.0','0.0']
    where = ''
    measurement_key.each_with_index do |tuple, idx|
      where += "#{tuple[0]} = '#{RangeSupport.range_to_string(tuple[1])}'"
      where += ' and ' unless idx == measurement_key.length - 1
    end
    measurement = Measurement.where(where).first
    if measurement.nil?
      measurement = Measurement.new(measurement_key)
      measurement.save
    end
    measurement
  end

  def defined_metrics
    metrics.select do |col|
      self[col].max > 0
    end
  end

  def self.activity_set_to_metric_map(activity_set_map, unit_map)
    calories_min = activity_set_map[:calories_min].to_i
    calories_max = activity_set_map[:calories_max].to_i
    cadence_min = activity_set_map[:cadence_min].to_f
    cadence_max = activity_set_map[:cadence_max].to_f
    distance_min = Unit.convert_to_meters(activity_set_map[:distance_min].to_f, unit_map[:distance_unit])
    distance_max = Unit.convert_to_meters(activity_set_map[:distance_max].to_f, unit_map[:distance_unit])
    duration_min = Unit.convert_to_seconds(activity_set_map[:duration_min], unit_map[:duration_unit])
    duration_max = Unit.convert_to_seconds(activity_set_map[:duration_max], unit_map[:duration_unit])
    heart_rate_min = activity_set_map[:heart_rate_min].to_i
    heart_rate_max = activity_set_map[:heart_rate_max].to_i
    incline_min = activity_set_map[:incline_min].to_f
    incline_max = activity_set_map[:incline_max].to_f
    level_min = activity_set_map[:level_min].to_i
    level_max = activity_set_map[:level_max].to_i
    repetitions_min = activity_set_map[:repetitions_min].to_i
    repetitions_max = activity_set_map[:repetitions_max].to_i
    resistance_min = Unit.convert_to_kilograms(activity_set_map[:resistance_min].to_f, unit_map[:resistance_unit])
    resistance_max = Unit.convert_to_kilograms(activity_set_map[:resistance_max].to_f, unit_map[:resistance_unit])
    speed_min = Unit.convert_to_kilometers_per_hour(activity_set_map[:speed_min].to_f, unit_map[:speed_unit])
    speed_max = Unit.convert_to_kilometers_per_hour(activity_set_map[:speed_max].to_f, unit_map[:speed_unit])

    metric_map = {
      :calories => calories_min .. (calories_max > calories_min ? calories_max : calories_min),
      :cadence => cadence_min .. (cadence_max > cadence_min ? cadence_max : cadence_min),
      :distance => distance_min .. (distance_max > distance_min ? distance_max : distance_min),
      :duration => duration_min .. (duration_max > duration_min ? duration_max : duration_min),
      :heart_rate => heart_rate_min .. (heart_rate_max > heart_rate_min ? heart_rate_max : heart_rate_min),
      :incline => incline_min .. (incline_max > incline_min ? incline_max : incline_min),
      :level => level_min .. (level_max > level_min ? level_max : level_min),
      :repetitions => repetitions_min .. (repetitions_max > repetitions_min ? repetitions_max : repetitions_min),
      :resistance => resistance_min .. (resistance_max > resistance_min ? resistance_max : resistance_min),
      :speed => speed_min .. (speed_max > speed_min ? speed_max : speed_min)
    }
    metric_map
  end

  def from_ranges
    metrics.each do |metric|
      self[metric] = RangeSupport.range_to_string(self[metric])
    end
  end

  def to_ranges
    metrics.each do |metric|
      self[metric] = RangeSupport.string_to_range(self[metric])
    end
  end

end
