class WeekdayProgram < ActiveRecord::Base
  belongs_to :routine
  belongs_to :program
end
