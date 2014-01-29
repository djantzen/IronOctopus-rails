class RecurringAppointment < Appointment
  set_table_name "recurring_appointments"


  #require "#{Rails.root.to_s}/lib/postgres_range_support"
  #
  #belongs_to :trainer, :class_name => "User", :foreign_key => :trainer_id
  #belongs_to :client, :class_name => "User", :foreign_key => :client_id
  #after_find :to_ranges # translate from database ranges
  #after_save :to_ranges # repair the one in memory after save
  #before_save :from_ranges # translate to database ranges
  #
  #def from_ranges
  #  self[:date_time_slot] = RangeSupport.range_to_string(self[:date_time_slot])
  #end
  #
  #def to_ranges
  #  self[:date_time_slot] = RangeSupport.string_to_range(self[:date_time_slot])
  #end
  #
  #
  #def local_date_time_slot
  #  date_time_slot_min_in_time_zone = date_time_slot.min.in_time_zone(trainer.timezone.tzid)
  #  date_time_slot_max_in_time_zone = date_time_slot.max.in_time_zone(trainer.timezone.tzid)
  #  DateTimeRange.new(date_time_slot_min_in_time_zone, date_time_slot_max_in_time_zone)
  #end

  def routines
    []
  end

end
