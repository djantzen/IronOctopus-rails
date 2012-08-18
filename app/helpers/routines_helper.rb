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

  def kilometers_to_miles(kilometers)
    kilometers * 0.6214
  end

  def miles_to_kilometers(miles)
    miles * 1.609
  end

  def miles_to_meters(miles)
    miles * 1609.3
  end

  def kilograms_to_pounds(kilograms)
    kilograms * 2.2046
  end

  def pounds_to_kilograms(pounds)
    pounds * 0.4536
  end

  def kph_to_mph(kph)
    kph * 0.6213
  end

  def mph_to_kph(mph)
    mph * 1.6093
  end

  def minutes_to_seconds(minutes)
    minutes * 60.0
  end

  def seconds_to_minutes(seconds)
    seconds / 60.0
  end

end
