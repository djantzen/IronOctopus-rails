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
end
