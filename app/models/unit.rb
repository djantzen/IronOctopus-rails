class Unit < ActiveRecord::Base

  has_many :routines, :through => :activity_sets
  has_many :activity_sets
  belongs_to :metric

  def self.lookup(unit)
    return Unit.find_by_name('None') if unit.nil?
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
    return resistance.to_f if resistance.nil? || from_unit.nil? || from_unit.eql?('None')
    case from_unit
      when 'Kilogram'
        resistance.to_f
      when 'Pound'
        pounds_to_kilograms(resistance)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to kilograms")
    end
  end

  def self.convert_from_kilograms(resistance, to_unit)
    return resistance.to_f if resistance.nil? || to_unit.nil? || to_unit.eql?('None')
    case to_unit
      when 'Kilogram'
        resistance.to_f
      when 'Pound'
        kilograms_to_pounds(resistance)
      else
        raise ArgumentError.new("Cannot convert #{to_unit} from kilograms")
    end
  end

  def self.convert_to_meters(distance, from_unit)
    return distance.to_f if distance.nil? || from_unit.nil? || from_unit.eql?('None')
    case from_unit
      when 'Meter'
        distance.to_f
      when 'Kilometer'
        kilometers_to_meters(distance)
      when 'Mile'
        miles_to_meters(distance)
      when 'Yard'
        yards_to_meters(distance)
      when 'Foot'
        feet_to_meters(distance)
      when /(\d+) Meter Lap/
        distance.to_f * $1.to_f
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to meters")
    end
  end

  def self.convert_from_meters(distance, to_unit)
    return distance.to_f if distance.nil? || to_unit.nil? || to_unit.eql?('None')
    case to_unit
      when 'Meter'
        distance.to_f
      when 'Kilometer'
        meters_to_kilometers(distance).round(1)
      when 'Mile'
        meters_to_miles(distance).round(1)
      when 'Yard'
        meters_to_yards(distance).round(5)
      when 'Foot'
        meters_to_feet(distance).round(1)
      when /(\d+) Meter Lap/
        distance / $1.to_f.round(1)
      else
        raise ArgumentError.new("Cannot convert #{to_unit} to meters")
    end
  end

  def self.convert_to_kilometers_per_hour(speed, from_unit)
    return speed.to_f if speed.nil? || from_unit.nil? || from_unit.eql?('None')
    case from_unit
      when 'Kilometer per Hour'
        speed.to_f
      when 'Mile per Hour'
        mph_to_kph(speed)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to kilometers per hour")
    end
  end

  def self.convert_from_kilometers_per_hour(speed, to_unit)
    return speed.to_f if speed.nil? || to_unit.nil? || to_unit.eql?('None')
    case to_unit
      when 'Kilometer per Hour'
        speed.to_f
      when 'Mile per Hour'
        kph_to_mph(speed)
      else
        raise ArgumentError.new("Cannot convert #{to_unit} from kilometers per hour")
    end
  end

  def self.convert_to_seconds(duration, from_unit)
    return duration.to_i if duration.nil?
    case from_unit
      when 'Second'
        duration
      when 'Minute'
        minutes_to_seconds(duration)
      when 'None'
        digital_to_seconds(duration)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to seconds")
    end
  end

  def self.convert_from_seconds(duration, to_unit)
    return duration.to_i if duration.nil? || to_unit.nil?
    #case to_unit
    #  when 'None'
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
