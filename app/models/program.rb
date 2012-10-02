class Program < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User', :foreign_key => :trainer_id
  belongs_to :client, :class_name => 'User', :foreign_key => :client_id

  has_many :routines_programs, :class_name => 'RoutineProgram', :foreign_key => :program_id
  has_many :routines, :through => :routines_programs, :class_name => 'Routine'

  before_validation { self.permalink = self.name.to_identifier }

  validates_presence_of :name
  validates_presence_of :goal
  validates_uniqueness_of :permalink

end
