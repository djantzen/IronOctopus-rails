class Weekday
  attr_accessor :name
  attr_accessor :abbr
  attr_accessor :code

  def initialize(name, abbr, code)
    self.name = name
    self.abbr = abbr
    self.code = code
  end

  SUNDAY = Weekday.new('Sunday', 'Sun', 1)
  MONDAY = Weekday.new('Monday', 'Mon', 2)
  TUESDAY = Weekday.new('Tuesday', 'Tue', 4)
  WEDNESDAY = Weekday.new('Wednesday', 'Wed', 8)
  THURSDAY = Weekday.new('Thursday', 'Thu', 16)
  FRIDAY = Weekday.new('Friday', 'Fri', 32)
  SATURDAY = Weekday.new('Saturday', 'Sat', 64)

  WEEK = [ SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY ]

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

