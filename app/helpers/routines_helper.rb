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

  def get_initial_value(activity_set, metric)
    metric_name = metric.name.downcase
    unit_column_name = "#{metric_name}_unit" # distance_unit, duration_unit, resistance_unit, speed_unit
    raw_value = activity_set.nil? ? 1 : (eval("activity_set.measurement.#{metric_name}"))
    case unit_column_name
      when 'distance_unit'
        [ Unit.convert_from_meters(raw_value, activity_set.distance_unit.name).round(1), activity_set.distance_unit.name ]
      when 'duration_unit'
        [ Unit.convert_from_seconds(raw_value, activity_set.duration_unit.name).round(1), activity_set.duration_unit.name ]
      when 'resistance_unit'
        [ Unit.convert_from_kilograms(raw_value, activity_set.resistance_unit.name).round(1), activity_set.resistance_unit.name ]
      when 'speed_unit'
        [ Unit.convert_from_kilometers_per_hour(raw_value, activity_set.speed_unit.name).round(1), activity_set.speed_unit.name ]
      else
        [ raw_value, 'None' ]
    end
  end

end
