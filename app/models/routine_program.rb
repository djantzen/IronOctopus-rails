class RoutineProgram < ActiveRecord::Base

  set_table_name 'routines_programs'
  set_primary_keys :routine_id, :program_id

  has_one :program_weekdays, :class_name => 'ProgramWeekdays', :foreign_key => [:routine_id, :program_id]

  belongs_to :routine, :class_name => 'Routine', :foreign_key => :routine_id
  belongs_to :program, :class_name => 'Program', :foreign_key => :program_id

end
