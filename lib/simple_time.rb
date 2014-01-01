class SimpleTime
  include Comparable
  attr_reader :hour
  attr_reader :minute
  attr_reader :second
  attr_reader :date_time

  def initialize(hour, minute, second)
    @hour = hour
    @minute = minute
    @second = second
    @date_time = DateTime.new(-4712, 1, 1, hour, minute, second)
  end

  def succ
    @date_time + 1.second
  end

  def <=>(other)
    @date_time <=> other.date_time
  end

  def to_s
    sprintf("%02d:%02d:%02d", @hour, @minute, @second)
  end

end