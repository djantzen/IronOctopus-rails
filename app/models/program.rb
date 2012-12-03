class Program < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User', :foreign_key => :trainer_id
  belongs_to :client, :class_name => 'User', :foreign_key => :client_id

  has_many :weekday_programs
  has_many :scheduled_programs

  VALIDATIONS = IronOctopus::Configuration.instance.validations[:program]
  validates :name, :length => {
    :minimum => VALIDATIONS[:name][:minlength].to_i,
    :maximum => VALIDATIONS[:name][:maxlength].to_i
  }
  validates :goal, :length => {
    :minimum => VALIDATIONS[:goal][:minlength].to_i,
    :maximum => VALIDATIONS[:goal][:maxlength].to_i
  }

  before_validation { self.permalink = self.name.to_identifier }
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
