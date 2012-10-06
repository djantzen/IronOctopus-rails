class Program < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User', :foreign_key => :trainer_id
  belongs_to :client, :class_name => 'User', :foreign_key => :client_id

  has_many :routines_programs, :class_name => 'RoutineProgram', :foreign_key => :program_id
  has_many :routines, :through => :routines_programs, :class_name => 'Routine'
  has_many :program_weekdays, :through => :routines_programs, :foreign_key => [:routine_id, :program_id]

  before_validation { self.permalink = self.name.to_identifier }

  validates_presence_of :name
  validates_presence_of :goal
  validates_uniqueness_of :permalink

  def to_param
    permalink
  end

  def to_s
    name
  end

end
