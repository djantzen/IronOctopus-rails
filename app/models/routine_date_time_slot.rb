class RoutineDateTimeSlot < ActiveRecord::Base
  require "#{Rails.root.to_s}/lib/postgres_range_support"

  belongs_to :routine
  after_find :to_ranges # translate from database ranges
  after_save :to_ranges # repair the one in memory after save
  before_save :from_ranges # translate to database ranges

  def from_ranges
    self[:date_time_slot] = RangeSupport.range_to_string(self[:date_time_slot])
  end

  def to_ranges
    self[:date_time_slot] = RangeSupport.string_to_range(self[:date_time_slot])
  end

  def self.find_by_date_time_slot_wrapper(date_time_range)
    self.find_by_date_time_slot(RangeSupport.range_to_string(date_time_range))
  end

end
