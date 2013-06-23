class Unit < ActiveRecord::Base

  has_many :routines, :through => :activity_sets
  has_many :activity_sets
  belongs_to :metric

  PRECISION = 3

  DEGREE = Unit.find_by_name("Degree")
  FIFTY_METER_LAP = Unit.find_by_name("50 Meter Lap")
  FOUR_HUNDRED_METER_LAP = Unit.find_by_name("400 Meter Lap")
  FOOT = Unit.find_by_name("Foot")
  KILOGRAM = Unit.find_by_name("Kilogram")
  KILOMETER = Unit.find_by_name("Kilometer")
  KILOMETERS_PER_HOUR = Unit.find_by_name("Kilometer per Hour")
  MILES_PER_HOUR = Unit.find_by_name("Mile per Hour")
  POUND = Unit.find_by_name("Pound")
  METER = Unit.find_by_name("Meter")
  MILE = Unit.find_by_name("Mile")
  MINUTE = Unit.find_by_name("Minute")
  NONE = Unit.find_by_name("None")
  REVOLUTIONS_PER_MINUTE = Unit.find_by_name("Revolution per Minute")
  SECOND = Unit.find_by_name("Second")
  TWENTY_FIVE_METER_LAP = Unit.find_by_name("25 Meter Lap")
  TWO_HUNDRED_FIFTY_METER_LAP = Unit.find_by_name("250 Meter Lap")
  YARD = Unit.find_by_name("Yard")

  def self.lookup(unit)
    return NONE if unit.nil?
    Unit.find_by_name(unit.singularize)
  end

  def self.kilometers_to_miles(kilometers)
    kilometers * 0.6214
  end

  def self.kilometers_to_meters(kilometers)
    kilometers * 1000.0
  end

  def self.meters_to_kilometers(meters)
    meters / 1000
  end

  def self.yards_to_meters(yards)
    yards * 0.9144
  end

  def self.meters_to_yards(meters)
    meters * 1.09361
  end

  def self.feet_to_meters(feet)
    feet * 0.3048
  end

  def self.meters_to_feet(meters)
    meters * 3.28084
  end

  def self.miles_to_kilometers(miles)
    miles * 1.60934
  end

  def self.meters_to_miles(meters)
    meters * 0.000621371
  end

  def self.miles_to_meters(miles)
    miles * 1609.344
  end

  def self.kilograms_to_pounds(kilograms)
    kilograms * 2.20462
  end

  def self.pounds_to_kilograms(pounds)
    pounds * 0.453592
  end

  def self.kph_to_mph(kph)
    kph * 0.621371
  end

  def self.mph_to_kph(mph)
    mph * 1.60934
  end

  def self.minutes_to_seconds(minutes)
    minutes * 60.0
  end

  def self.seconds_to_minutes(seconds)
    seconds / 60.0
  end

  def self.seconds_to_digital(seconds)
    format = "%d:%02d"
    digital = if seconds <= 60
                sprintf(format, 0, seconds)
              else
                minutes = seconds / 60
                remaining_seconds = seconds % 60
                sprintf(format, minutes, remaining_seconds)
              end
    digital
  end

  def self.digital_to_seconds(digital)
    return digital.to_i unless digital =~ /^\d{1,3}:\d{1,2}$/
    minutes, seconds = digital.split(':').map do |s|
      int = s.to_i
    end
    (minutes * 60) + seconds
  end

  def self.convert_to_kilograms(resistance, from_unit)
    return resistance.to_f if resistance.nil? || from_unit.nil? || from_unit.eql?(NONE)
    case from_unit
      when Unit::KILOGRAM
        resistance.to_f
      when Unit::POUND
        pounds_to_kilograms(resistance)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to kilograms")
    end
  end

  def self.convert_from_kilograms(resistance, to_unit)
    return resistance.to_f if resistance.nil? || to_unit.nil? || to_unit.eql?(NONE)
    case to_unit
      when KILOGRAM
        resistance.to_f
      when POUND
        round kilograms_to_pounds(resistance)
      else
        raise ArgumentError.new("Cannot convert #{to_unit} from kilograms")
    end
  end

  def self.convert_to_meters(distance, from_unit)
    return distance.to_f if distance.nil? || from_unit.nil? || from_unit.eql?(NONE)
    case from_unit
      when METER
        distance.to_f
      when KILOMETER
        kilometers_to_meters(distance)
      when MILE
        miles_to_meters(distance)
      when YARD
        yards_to_meters(distance)
      when FOOT
        feet_to_meters(distance)
      when TWENTY_FIVE_METER_LAP
        distance.to_f * 25
      when FIFTY_METER_LAP
        distance.to_f * 50
      when TWO_HUNDRED_FIFTY_METER_LAP
        distance.to_f * 250
      when FOUR_HUNDRED_METER_LAP
        distance.to_f * 400
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to meters")
    end
  end

  def self.convert_from_meters(distance, to_unit)
    return distance.to_f if distance.nil? || to_unit.nil? || to_unit.eql?(NONE)
    case to_unit
      when METER
        distance.to_f
      when KILOMETER
        meters_to_kilometers(distance)
      when MILE
        round meters_to_miles(distance)
      when YARD
        round meters_to_yards(distance)
      when FOOT
        round meters_to_feet(distance)
      when TWENTY_FIVE_METER_LAP
        distance / 25
      when FIFTY_METER_LAP
        distance / 50
      when TWO_HUNDRED_FIFTY_METER_LAP
        distance / 250
      when FOUR_HUNDRED_METER_LAP
        distance / 400
      else
        raise ArgumentError.new("Cannot convert #{to_unit} to meters")
    end
  end

  def self.round(value)
    value.round(PRECISION)
  end

  def self.convert_to_kilometers_per_hour(speed, from_unit)
    return speed.to_f if speed.nil? || from_unit.nil? || from_unit.eql?(NONE)
    case from_unit
      when KILOMETERS_PER_HOUR
        speed.to_f
      when MILES_PER_HOUR
        mph_to_kph(speed)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to kilometers per hour")
    end
  end

  def self.convert_from_kilometers_per_hour(speed, to_unit)
    return speed.to_f if speed.nil? || to_unit.nil? || to_unit.eql?(NONE)
    case to_unit
      when KILOMETERS_PER_HOUR
        speed.to_f
      when MILES_PER_HOUR
        round kph_to_mph(speed)
      else
        raise ArgumentError.new("Cannot convert #{to_unit} from kilometers per hour")
    end
  end

  def self.convert_to_seconds(duration, from_unit)
    return duration.to_i if duration.nil?
    case from_unit
      when SECOND
        duration
      when MINUTE
        minutes_to_seconds(duration)
      when NONE
        digital_to_seconds(duration)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to seconds")
    end
  end

  def self.convert_from_seconds(duration, to_unit)
    return duration.to_i if duration.nil? || to_unit.nil?
    #case to_unit
    #  when NONE
        seconds_to_digital(duration)
    #  when 'Second'
    #    duration.to_f
    #  when 'Minute'
    #    seconds_to_minutes(duration)
    #  else
    #    raise ArgumentError.new("Cannot convert #{to_unit} from seconds")
    #end
  end

  def to_s
    name
  end

  def self.activity_set_to_unit_map(activity_set_map)
    {
      :cadence_unit => Unit.lookup(activity_set_map[:cadence_unit]),
      :distance_unit => Unit.lookup(activity_set_map[:distance_unit]),
      :duration_unit => Unit.lookup(activity_set_map[:duration_unit]),
      :speed_unit => Unit.lookup(activity_set_map[:speed_unit]),
      :resistance_unit => Unit.lookup(activity_set_map[:resistance_unit])
    }
  end

end
