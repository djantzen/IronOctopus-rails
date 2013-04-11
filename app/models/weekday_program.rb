class WeekdayProgram < ActiveRecord::Base
  belongs_to :routine
  belongs_to :program

  def on
    day_of_week
  end

end
