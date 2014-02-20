require 'test_helper'

class RecurringAppointmentRulesControllerTest < ActionController::TestCase
  test "create a rule" do
    date_time_slot = DateTimeRange.new(DateTime.new(2013, 9, 5, 3, 0, 0), DateTime.new(2013, 9, 5, 3, 59, 59))
    weekday = Weekday.from_day_of_week(date_time_slot.min.cwday)
    time_slot = SimpleTimeRange.new(SimpleTime.parse(date_time_slot.min.iso8601), SimpleTime.parse(date_time_slot.max.iso8601))
    trainer = User.find_by_login("bob_the_trainer")
    client = User.find_by_login("sally_the_client")
    params = {
      :format => "js",
      :user_id => trainer.login,
      :recurring_appointment_rule => {:client_login => client.login, :date_time_slot_id => date_time_slot.to_identifier}
    }

    post :create, params
    assert_response :success
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer.user_id, :day_of_week => weekday.name, :time_slot => time_slot.to_query).first)

  end

  test "delete a rule" do

    date_time_slot = DateTimeRange.new(DateTime.new(2013, 9, 5, 3, 0, 0), DateTime.new(2013, 9, 5, 4, 59, 59))
    weekday = Weekday.from_day_of_week(date_time_slot.min.cwday)
    time_slot = SimpleTimeRange.new(SimpleTime.parse(date_time_slot.min.iso8601), SimpleTime.parse(date_time_slot.max.iso8601))
    trainer_1 = User.find_by_login("bob_the_trainer")
    trainer_2 = User.find_by_login("mary_the_trainer")
    client_1 = User.find_by_login("sally_the_client")
    client_2 = User.find_by_login("jim_the_client")

    create_params_1 = {
      :format => "js",
      :user_id => trainer_1.login,
      :recurring_appointment_rule => {:client_login => client_1.login, :date_time_slot_id => date_time_slot.to_identifier}
    }

    create_params_2 = {
      :format => "js",
      :user_id => trainer_2.login,
      :recurring_appointment_rule => {:client_login => client_2.login, :date_time_slot_id => date_time_slot.to_identifier}
    }

    post :create, create_params_1
    assert_response :success
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer_1.user_id, :time_slot => time_slot.to_query).first)

    post :create, create_params_2
    assert_response :success
    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer_2.user_id, :time_slot => time_slot.to_query).first)

    destroy_params = {
      :format => "js",
      :user_id => trainer_1.login,
      :id => date_time_slot.to_identifier
    }

    delete :destroy, destroy_params
    assert_response :success
    assert_nil(RecurringAppointmentRule.where(:trainer_id => trainer_1.user_id, :day_of_week => weekday.name, :time_slot => time_slot.to_query).first)

    assert_not_nil(RecurringAppointmentRule.where(:trainer_id => trainer_2.user_id, :day_of_week => weekday.name, :time_slot => time_slot.to_query).first)

  end

end
