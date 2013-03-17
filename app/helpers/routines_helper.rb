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
    attr_reader :value
    def initialize(value)
      @value = value
    end

    def defined?
      return @value > 0
    end
  end

  class DurationMeasureValue < MeasureValue
    def defined?
      return value != ":00"
    end
  end

  def get_initial_value(activity_set, metric)
    return [ MeasureValue.new(0), nil] if activity_set.nil?

    metric_name = metric.name.downcase.gsub(/\s/, '_')
    unit_column_name = "#{metric_name}_unit" # distance_unit, duration_unit, resistance_unit, speed_unit
    raw_value = activity_set.measurement.send metric_name
    case unit_column_name
      when 'distance_unit'
        unit_name = activity_set.unit_set.distance_unit.name
        value = Unit.convert_from_meters(raw_value, unit_name).round
        [ MeasureValue.new(value) , unit_name ]
      when 'duration_unit'
        unit_name = activity_set.unit_set.duration_unit.name
        value = Unit.convert_from_seconds(raw_value, unit_name)
        [ DurationMeasureValue.new(value), unit_name ]
      when 'resistance_unit'
        unit_name = activity_set.unit_set.resistance_unit.name
        value = Unit.convert_from_kilograms(raw_value, unit_name).round
        [ MeasureValue.new(value), unit_name ]
      when 'speed_unit'
        unit_name = activity_set.unit_set.speed_unit.name
        value = Unit.convert_from_kilometers_per_hour(raw_value, unit_name).round
        [ MeasureValue.new(value), unit_name ]
      else
        [ MeasureValue.new(raw_value), 'None' ]
    end
  end

end
