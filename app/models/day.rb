class Day < ActiveRecord::Base

  has_many :work, :class_name => 'Work', :foreign_key => 'start_day_id'
  
  def self.find_or_create(arg)

    date = if arg.is_a?(String) then
      Date.parse(arg)
    elsif arg.is_a?(Date) then
      arg
    elsif arg.is_a?(Time) then
      arg.to_date
    else
      raise ArgumentError, "Argument must a date or string"
    end
    
    the_day = Day.find_by_full_date(date)
    if the_day.nil?
      the_day = from_date(date)
      the_day.save
    end
    the_day
  end

  def self.as_smart_id(date)
    raise ArgumentError "Argument must a date or time" unless date.is_a? Date or date.is_a? Time
    date.strftime("%Y%m%d").to_i
  end

  def to_s
    "Day #{day_id} is #{full_date}, #{year}, #{month}, #{day}"
  end

  private

  def self.from_date(date)
    raise ArgumentError "Argument must time" unless date.is_a? Date
    day_of_week = case
                    when date.sunday? then "Sunday"
                    when date.monday? then "Monday"
                    when date.tuesday? then "Tuesday"
                    when date.wednesday? then "Wednesday"
                    when date.thursday? then "Thursday"
                    when date.friday? then "Friday"
                    when date.saturday? then "Saturday"
                  end

    the_day = Day.new(:full_date => date, :year => date.year, :month => date.month,
                      :day => date.day, :day_of_week => day_of_week)
    the_day.day_id = as_smart_id(date)
    the_day
  end


end
