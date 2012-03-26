class Day < ActiveRecord::Base
  has_many :work, :class_name => 'Work', :foreign_key => 'start_day_id'
  
  def self.as_smart_id(time)
    Time.parse(time).strftime("%Y%m%d").to_i
  end

  def self.from_time(time)
    the_day = Day.new(:full_date => time.to_date, :year => time.to_date.year,
                      :month => time.to_date.month, :day => time.to_date.day)
    the_day.day_id = as_smart_id(time)
    the_day
  end
  
  def self.find_or_create(time)
    the_day = Day.find_by_full_date(time.to_date)
    if the_day.nil?
      the_day = from_time(time)
      the_day.save
    end
    the_day
  end
end
