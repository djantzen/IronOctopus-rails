class Weekday
  attr_accessor :name
  attr_accessor :abbr
  attr_accessor :code
  attr_accessor :day_of_week

  def initialize(name, abbr, day_of_week, code)
    self.name = name
    self.abbr = abbr
    self.day_of_week = day_of_week
    self.code = code
  end

  SUNDAY = Weekday.new('Sunday', 'Sun', 1, 1)
  MONDAY = Weekday.new('Monday', 'Mon', 2, 2)
  TUESDAY = Weekday.new('Tuesday', 'Tue', 3, 4)
  WEDNESDAY = Weekday.new('Wednesday', 'Wed', 4, 8)
  THURSDAY = Weekday.new('Thursday', 'Thu', 5, 16)
  FRIDAY = Weekday.new('Friday', 'Fri', 6, 32)
  SATURDAY = Weekday.new('Saturday', 'Sat', 7, 64)

  WEEK = [ SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY ]

  def self.from_day_of_week(day_of_week)
    WEEK.select do |day|
      day.day_of_week == day_of_week
    end
  end

  def self.from_code(code)
    WEEK.select do |day|
      code & day.code > 0
    end
  end

  def self.to_code(weekdays)
    weekdays.inject(0) do |int, weekday|
      int + weekday.code
    end
  end

end

