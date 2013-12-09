require 'test_helper'

class RecurringAppointments < ActiveSupport::TestCase

  test "Sally is scheduled on the next Tuesday afternoon (Wednesday UTC)" do
    trainer = User.find_by_login("bob_the_trainer")
    sallys_appointments = trainer.recurring_appointments.where(:login => "sally_the_client")
    assert_equal(DateTime.parse("2013-09-04 02:00:00"), sallys_appointments[0].date_time_slot.min)
    assert_equal(DateTime.parse("2013-09-04 03:00:00"), sallys_appointments[0].date_time_slot.max)
  end

  test "Sally is scheduled on the next Thursday morning" do
    trainer = User.find_by_login("bob_the_trainer")
    sallys_appointments = trainer.recurring_appointments.where(:login => "sally_the_client")
    assert_equal(DateTime.parse("2013-09-05 20:00:00"), sallys_appointments[1].date_time_slot.min)
    assert_equal(DateTime.parse("2013-09-05 21:00:00"), sallys_appointments[1].date_time_slot.max)
  end



end
