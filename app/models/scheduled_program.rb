class ScheduledProgram < ActiveRecord::Base
  belongs_to :routine
  belongs_to :program

  def on
    scheduled_on
  end

end
