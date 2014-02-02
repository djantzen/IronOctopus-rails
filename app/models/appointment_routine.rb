class AppointmentRoutine < ActiveRecord::Base
  belongs_to :appointment
  belongs_to :routine
end