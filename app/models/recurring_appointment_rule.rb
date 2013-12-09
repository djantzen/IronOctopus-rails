class RecurringAppointmentRule < ActiveRecord::Base
  require "#{Rails.root.to_s}/lib/postgres_range_support"

  belongs_to :trainer, :class_name => "User", :foreign_key => :trainer_id
  belongs_to :client, :class_name => "User", :foreign_key => :client_id
  after_find :to_ranges # translate from database ranges
  after_save :to_ranges # repair the one in memory after save
  before_save :from_ranges # translate to database ranges

  def from_ranges
    self[:time_slot] = RangeSupport.range_to_string(self[:time_slot])
  end

  def to_ranges
    self[:time_slot] = RangeSupport.string_to_range(self[:time_slot])
  end


end
