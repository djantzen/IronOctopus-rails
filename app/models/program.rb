class Program < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User', :foreign_key => :trainer_id
  belongs_to :client, :class_name => 'User', :foreign_key => :client_id

  has_many :weekday_programs
  has_many :scheduled_programs

#  has_one :client, :through => :active_programs

  before_validation { self.permalink = self.name.to_identifier }

  validates_presence_of :name
  validates_presence_of :goal
  validates_uniqueness_of :permalink

  def is_weekday_program?
    weekday_programs.size > 0 && scheduled_programs.size == 0
  end

  def is_scheduled_program?
    scheduled_programs.size > 0 && weekday_programs.size == 0
  end

  def program_type
    return 'Weekday Program' if is_weekday_program?
    return 'Scheduled Program' if is_scheduled_program?
  end

  def to_param
    permalink
  end

  def to_s
    "#{program_type}: #{name}"
  end

end
