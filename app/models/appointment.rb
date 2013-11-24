class Appointment < ActiveRecord::Base
  require Rails.root.to_s + '/lib/postgres_range_support'

  belongs_to :trainer, :class_name => "User", :foreign_key => :trainer_id
  belongs_to :client, :class_name => "User", :foreign_key => :client_id

  def from_ranges
    self[:time_slot] = RangeSupport.range_to_string(self[:time_slot])
  end

  def to_ranges
    self[:time_slot] = RangeSupport.string_to_range(self[:time_slot])
  end

end
