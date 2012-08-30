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
    kilometers * 100.0
  end

  def self.meters_to_kilometers(meters)
    meters / 100
  end

  def self.miles_to_kilometers(miles)
    miles * 1.60934
  end

  def self.meters_to_miles(meters)
    meters * 0.000621371
  end

  def self.miles_to_meters(miles)
    miles * 1609.34
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

  def self.convert_to_kilograms(resistance, from_unit)
    return if resistance.nil? || from_unit.nil? || from_unit.eql?('None')
    case from_unit
      when 'Kilogram'
        resistance
      when 'Pound'
        pounds_to_kilograms(resistance)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to kilograms")
    end
  end

  def self.convert_from_kilograms(resistance, to_unit)
    return if resistance.nil? || to_unit.nil? || to_unit.eql?('None')
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
    return if distance.nil? || from_unit.nil? || from_unit.eql?('None')
    case from_unit
      when 'Meter'
        distance
      when 'Kilometer'
        kilometers_to_meters(distance)
      when 'Mile'
        miles_to_meters(distance)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to meters")
    end
  end

  def self.convert_from_meters(distance, to_unit)
    return if distance.nil? || to_unit.nil? || to_unit.eql?('None')
    case to_unit
      when 'Meter'
        distance.to_f
      when 'Kilometer'
        meters_to_kilometers(distance)
      when 'Mile'
        meters_to_miles(distance)
      else
        raise ArgumentError.new("Cannot convert #{to_unit} to meters")
    end
  end

  def self.convert_to_kilometers_per_hour(speed, from_unit)
    return if speed.nil? || from_unit.nil? || from_unit.eql?('None')
    case from_unit
      when 'Kilometer per Hour'
        speed
      when 'Mile per Hour'
        mph_to_kph(speed)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to kilometers per hour")
    end
  end

  def self.convert_from_kilometers_per_hour(speed, to_unit)
    return if speed.nil? || to_unit.nil? || to_unit.eql?('None')
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
    return if duration.nil? || from_unit.nil? || from_unit.eql?('None')
    case from_unit
      when 'Second'
        duration
      when 'Minute'
        minutes_to_seconds(duration)
      else
        raise ArgumentError.new("Cannot convert #{from_unit} to seconds")
    end
  end

  def self.convert_from_seconds(duration, to_unit)
    return if duration.nil? || to_unit.nil? || to_unit.eql?('None')
    case to_unit
      when 'Second'
        duration.to_f
      when 'Minute'
        seconds_to_minutes(duration)
      else
        raise ArgumentError.new("Cannot convert #{to_unit} from seconds")
    end
  end


end
