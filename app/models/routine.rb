class Routine < ActiveRecord::Base

  belongs_to :trainer, :class_name => "User", :foreign_key => :trainer_id
  belongs_to :client, :class_name => "User", :foreign_key => :client_id
 
  has_many :activities, :through => :activity_sets
  has_many :measurements, :through => :activity_sets
  has_many :activity_set_groups, :dependent => :destroy
  has_many :activity_sets, :through => :activity_set_groups, :order => :position, :dependent => :destroy

  has_many :weekday_programs
  has_many :scheduled_programs

  has_many :routine_date_time_slots, :dependent => :delete_all

  def date_time_slot
    routine_date_time_slots.empty? ? nil : routine_date_time_slots.first.date_time_slot
  end

  #has_many :recurrences, :class_name => "RoutineRecurrences"

  VALIDATIONS = IronOctopus::Configuration.instance.validations[:routine]
  validates :name, :length => {
    :minimum => VALIDATIONS[:name][:minlength].to_i,
    :maximum => VALIDATIONS[:name][:maxlength].to_i
  }
  validates :goal, :length => {
    :minimum => VALIDATIONS[:goal][:minlength].to_i,
    :maximum => VALIDATIONS[:goal][:maxlength].to_i
  }

  before_validation { self.permalink = name.to_identifier }
  validates_uniqueness_of :permalink, :scope => :client_id

  def to_param
    permalink
  end

  def to_s
    name
  end
end
