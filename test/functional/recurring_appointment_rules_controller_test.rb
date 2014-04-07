require 'test_helper'

class RecurringAppointmentRulesControllerTest < ActionController::TestCase
  test "create a rule" do
    time_slot = SimpleTimeRange.new(SimpleTime.parse("14:30:00"), SimpleTime.parse("15:30:00"))
    day_of_week = "Thursday"
    trainer = User.find_by_login("bob_the_trainer")
    client = User.find_by_login("sally_the_client")
    params = {
      :format => "js",
      :user_id => trainer.login,
      :recurring_appointment_rule => {:client_login => client.login, :time_slot_id => time_slot.to_identifier,
                                      :day_of_week => day_of_week}
    }

    post :create, params
    assert_response :success
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer.user_id, :day_of_week => day_of_week, 
                                                  :time_slot => time_slot.to_query).first)
  end

  test "delete a rule" do
    time_slot = SimpleTimeRange.new(SimpleTime.parse("13:30:00"), SimpleTime.parse("14:30:00"))
    day_of_week = "Wednesday"
    trainer_1 = User.find_by_login("bob_the_trainer")
    trainer_2 = User.find_by_login("mary_the_trainer")
    client_1 = User.find_by_login("sally_the_client")
    client_2 = User.find_by_login("jim_the_client")

    create_params_1 = {
      :format => "js",
      :user_id => trainer_1.login,
      :recurring_appointment_rule => {:client_login => client_1.login, :time_slot_id => time_slot.to_identifier,
                                      :day_of_week => day_of_week}
    }

    create_params_2 = {
      :format => "js",
      :user_id => trainer_2.login,
      :recurring_appointment_rule => {:client_login => client_2.login, :time_slot_id => time_slot.to_identifier,
                                      :day_of_week => day_of_week}
    }

    post :create, create_params_1
    assert_response :success
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer_1.user_id, :client_id => client_1.id, 
                                                  :time_slot => time_slot.to_query).first)

    post :create, create_params_2
    assert_response :success
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer_2.user_id, :client_id => client_2.id,
                                                  :time_slot => time_slot.to_query).first)

    destroy_params = {
      :format => "js",
      :user_id => trainer_1.login,
      :time_slot_id => time_slot.to_identifier,
      :day_of_week => day_of_week
    }

    delete :destroy, destroy_params
    assert_response :success
    assert_nil(RecurringAppointmentRule.where(:trainer_id => trainer_1.user_id, :day_of_week => day_of_week, 
                                              :time_slot => time_slot.to_query).first)

    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer_2.user_id, :day_of_week => day_of_week, 
                                                  :time_slot => time_slot.to_query).first)

  end

  test "update a rule" do
    time_slot = SimpleTimeRange.new(SimpleTime.parse("14:30:00"), SimpleTime.parse("15:30:00"))
    time_slot_2 = SimpleTimeRange.new(SimpleTime.parse("9:00:00"), SimpleTime.parse("9:00:00"))
    day_of_week = "Thursday"
    trainer = User.find_by_login("bob_the_trainer")
    client = User.find_by_login("sally_the_client")
    create_params = {
      :format => "js",
      :user_id => trainer.login,
      :recurring_appointment_rule => {:client_login => client.login, :time_slot_id => time_slot.to_identifier,
                                      :day_of_week => day_of_week}
    }

    post :create, create_params
    assert_response :success
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer.user_id, :day_of_week => day_of_week,
                                                  :time_slot => time_slot.to_query).first)

    create_params_2 = {
      :format => "js",
      :user_id => trainer.login,
      :recurring_appointment_rule => {:client_login => client.login, :time_slot_id => time_slot_2.to_identifier,
                                      :day_of_week => day_of_week}
    }

    post :create, create_params_2
    assert_response :success
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer.user_id, :client_id => client.id,
                                                  :time_slot => time_slot_2.to_query).first)

    new_time_slot = SimpleTimeRange.new(SimpleTime.parse("19:30:00"), SimpleTime.parse("20:30:00"))
    new_day_of_week = "Wednesday"
    update_params = {
      :format => "js",
      :user_id => trainer.login,
      :time_slot_id => time_slot.to_identifier,
      :day_of_week => day_of_week,
      :recurring_appointment_rule => { :client_login => client.login, :day_of_week => new_day_of_week,
                                       :time_slot_id => new_time_slot.to_identifier }
    }

    put :update, update_params
    assert_response :success
    assert_nil(RecurringAppointmentRule.where(:trainer_id => trainer.user_id, :day_of_week => day_of_week,
                                              :time_slot => time_slot.to_query).first)
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer.user_id, :day_of_week => new_day_of_week,
                                                  :time_slot => new_time_slot.to_query).first)
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer.user_id, :client_id => client.id,
                                                  :time_slot => time_slot_2.to_query).first)
  end


end
