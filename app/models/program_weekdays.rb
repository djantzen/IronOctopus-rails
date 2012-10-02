class ProgramWeekdays < ActiveRecord::Base
  set_table_name 'program_weekdays'
  belongs_to :routine_program, :foreign_key => [:routine_id, :program_id]

end
