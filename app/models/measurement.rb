class Measurement < ActiveRecord::Base
  require 'postgres_range_support'
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
      where += "#{tuple[0]} = '#{Measurement.range_to_string(tuple[1])}'"
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

  private

  def self.string_to_range(val)
    if val =~ /\[(\d+),(\d+)\]/
      ($1.to_i .. $2.to_i)
    elsif val =~ /\[(\d+),(\d+)\)/
      ($1.to_i .. $2.to_i - 1)
    elsif val =~ /\[(\d+\.\d+),(\d+\.\d+)\]/
      ($1.to_f .. $2.to_f)
    elsif val =~ /\[(\d+\.\d+),(\d+\.\d+)\)/
      ($1.to_f .. $2.to_f - 1)
    elsif val =~ /^(\d+)$/
      ($1.to_i .. $1.to_i)
    elsif val =~ /(\d+.\d+)/
      ($1.to_f .. $1.to_f)
    elsif val.kind_of?(Integer)
      (val .. val)
    end
  end

  def self.range_to_string(object)
    from = object.begin.respond_to?(:infinite?) && object.begin.infinite? ? '' : object.begin
    to   = object.end.respond_to?(:infinite?) && object.end.infinite? ? '' : object.end
    "[#{from},#{to}#{object.exclude_end? ? ')' : ']'}"
  end

  def from_ranges
    metrics.each do |metric|
      s = Measurement.range_to_string(self[metric])
      self[metric] = s
    end
  end

  def to_ranges
    metrics.each do |metric|
      r = Measurement.string_to_range(self[metric])
      self[metric] = r
    end
  end

end
