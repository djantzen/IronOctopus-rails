require 'test_helper'

class AppointmentsControllerTest < ActionController::TestCase
  test "create an appointment" do
    date_time_slot = DateTimeRange.new(DateTime.new(2013, 9, 5, 3, 0, 0), DateTime.new(2013, 9, 5, 4, 59, 59))
    trainer = User.find_by_login("bob_the_trainer")
    params = {
      :format => "js",
      :user_id => trainer.login,
      :appointment => {:client_login => "sally_the_client", :date_time_slot_id => date_time_slot.to_identifier}
    }

    post :create, params
    assert_response :success
    assert_not_nil(Appointment.where(:trainer_id => trainer.user_id, :date_time_slot => date_time_slot.to_query).first)
  end

  test "delete an appointment" do
    date_time_slot = DateTimeRange.new(DateTime.new(2013, 9, 5, 3, 0, 0), DateTime.new(2013, 9, 5, 4, 59, 59))
    trainer_1 = User.find_by_login("bob_the_trainer")
    trainer_2 = User.find_by_login("mary_the_trainer")
    params_1 = {
      :format => "js",
      :user_id => trainer_1.login,
      :appointment => {:client_login => "sally_the_client", :date_time_slot_id => date_time_slot.to_identifier}
    }

    params_2 = {
      :format => "js",
      :user_id => trainer_2.login,
      :appointment => {:client_login => "jim_the_client", :date_time_slot_id => date_time_slot.to_identifier}
    }

    params_3 = {
      :format => "js",
      :user_id => trainer_1.login,
      :id => date_time_slot.to_identifier
    }

    post :create, params_1
    assert_response :success
    assert_not_nil(Appointment.where(:trainer_id => trainer_1.user_id, :date_time_slot => date_time_slot.to_query).first)

    post :create, params_2
    assert_response :success
    assert_not_nil(Appointment.where(:trainer_id => trainer_2.user_id, :date_time_slot => date_time_slot.to_query).first)

    delete :destroy, params_3
    assert_response :success
    assert_nil(Appointment.where(:trainer_id => trainer_1.user_id, :date_time_slot => date_time_slot.to_query).first)

    assert_not_nil(Appointment.where(:trainer_id => trainer_2.user_id, :date_time_slot => date_time_slot.to_query).first)
  end

end
