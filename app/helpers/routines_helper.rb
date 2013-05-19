module RoutinesHelper
  
  def group_body_parts_by_region(body_parts)
    body_parts.inject({}) do |hash, body_part|
      hash[body_part.region] ||= []
      hash[body_part.region] << body_part
      hash
    end
  end

  def group_implements_by_category(implements)
    implements.inject({}) do |hash, implement|
      hash[implement.category] ||= []
      hash[implement.category] << implement
      hash
    end
  end

  class MeasureValue
    attr_reader :min
    attr_reader :max
    def initialize(min, max)
      @min = min
      @max = max
    end

    def range?
      max > min
    end

    def defined?
      return max > 0
    end
  end

  class DurationMeasureValue < MeasureValue
    def defined?
      return max != ":00"
    end
  end

  def get_initial_value(activity_set, metric)
    return [ MeasureValue.new(0, 0), nil] if activity_set.nil?

    metric_name = metric.name.downcase.gsub(/\s/, '_')
    unit_column_name = "#{metric_name}_unit" # distance_unit, duration_unit, resistance_unit, speed_unit
    raw_range_value = activity_set.measurement.send metric_name
    case unit_column_name
      when 'distance_unit'
        unit_name = activity_set.unit_set.distance_unit.name
        min = Unit.convert_from_meters(raw_range_value.min, unit_name).round(1)
        max = Unit.convert_from_meters(raw_range_value.max, unit_name).round(1)
        [ MeasureValue.new(min, max) , unit_name ]
      when 'duration_unit'
        unit_name = activity_set.unit_set.duration_unit.name
        min = Unit.convert_from_seconds(raw_range_value.min, unit_name)
        max = Unit.convert_from_seconds(raw_range_value.max, unit_name)
        [ DurationMeasureValue.new(min, max), unit_name ]
      when 'resistance_unit'
        unit_name = activity_set.unit_set.resistance_unit.name
        min = Unit.convert_from_kilograms(raw_range_value.min, unit_name).round(1)
        max = Unit.convert_from_kilograms(raw_range_value.max, unit_name).round(1)
        [ MeasureValue.new(min, max), unit_name ]
      when 'speed_unit'
        unit_name = activity_set.unit_set.speed_unit.name
        min = Unit.convert_from_kilometers_per_hour(raw_range_value.min, unit_name).round(1)
        max = Unit.convert_from_kilometers_per_hour(raw_range_value.max, unit_name).round(1)
        [ MeasureValue.new(min, max), unit_name ]
      else
        [ MeasureValue.new(raw_range_value.min, raw_range_value.max), 'None' ]
    end
  end

end
