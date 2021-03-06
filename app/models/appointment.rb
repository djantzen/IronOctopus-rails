class Appointment < ActiveRecord::Base
  require "#{Rails.root.to_s}/lib/postgres_range_support"

  belongs_to :trainer, :class_name => "User", :foreign_key => :trainer_id
  belongs_to :client, :class_name => "User", :foreign_key => :client_id
  has_one :appointment_routine
  has_one :routine, :through => :appointment_routine
  has_one :routine_date_time_slot, :through => :routine

  after_find :to_ranges # translate from database ranges
  after_save :to_ranges # repair the one in memory after save
  before_save :from_ranges # translate to database ranges

  after_destroy :unschedule_routine

  def unschedule_routine
    puts "hi"
  end

  def from_ranges
    self[:date_time_slot] = RangeSupport.range_to_string(self[:date_time_slot])
  end

  def to_ranges
    self[:date_time_slot] = RangeSupport.string_to_range(self[:date_time_slot])
  end

  def date
    date_time_slot.min.to_date
  end

  def local_date_time_slot
    date_time_slot_min_in_time_zone = date_time_slot.min.in_time_zone(trainer.timezone.tzid)
    date_time_slot_max_in_time_zone = date_time_slot.max.in_time_zone(trainer.timezone.tzid)
    DateTimeRange.new(date_time_slot_min_in_time_zone, date_time_slot_max_in_time_zone)
  end
end
