require 'test_helper'

class RecurringAppointmentRuleTest < ActiveSupport::TestCase

  test "create and read work" do
    trainer = User.find_by_login("bob_the_trainer")
    client = User.find_by_login("sally_the_client")
    wednesdays_at_9 = RecurringAppointmentRule.new(:trainer => trainer, :client => client, :day_of_week => "Wednesday",
                                                   :time_slot => SimpleTimeRange.new(SimpleTime.new(9, 0, 0), SimpleTime.new(9, 59, 59)))
    fridays_at_9 = RecurringAppointmentRule.new(:trainer => trainer, :client => client, :day_of_week => "Friday",
                                                :time_slot => SimpleTimeRange.new(SimpleTime.new(9, 0, 0), SimpleTime.new(9, 59, 59)))
    wednesdays_at_9.save
    fridays_at_9.save

    read_rules = RecurringAppointmentRule.where(:trainer_id => trainer.user_id,
                                                :day_of_week => "Wednesday",
                                                :time_slot => wednesdays_at_9.time_slot.to_query)
    assert_equal(1, read_rules.size)
    assert_not_nil(read_rules.first)
    assert_equal(wednesdays_at_9.time_slot, read_rules.first.time_slot)
  end

  test "delete a rule works" do
    trainer = User.find_by_login("bob_the_trainer")
    client = User.find_by_login("sally_the_client")
    wednesdays_at_9 = RecurringAppointmentRule.new(:trainer => trainer, :client => client, :day_of_week => "Wednesday",
                                                   :time_slot => SimpleTimeRange.new(SimpleTime.new(9, 0, 0), SimpleTime.new(9, 59, 59)))
    fridays_at_9 = RecurringAppointmentRule.new(:trainer => trainer, :client => client, :day_of_week => "Friday",
                                                :time_slot => SimpleTimeRange.new(SimpleTime.new(9, 0, 0), SimpleTime.new(9, 59, 59)))
    wednesdays_at_9.save
    fridays_at_9.save

    RecurringAppointmentRule.delete_all(:trainer_id => trainer.user_id,
                                        :day_of_week => "Wednesday",
                                        :time_slot => wednesdays_at_9.time_slot.to_query)

    read_rule_1 = RecurringAppointmentRule.where(:trainer_id => trainer.user_id,
                                                 :day_of_week => "Wednesday",
                                                 :time_slot => wednesdays_at_9.time_slot.to_query).first
    read_rule_2 = RecurringAppointmentRule.where(:trainer_id => trainer.user_id,
                                                 :day_of_week => "Friday",
                                                 :time_slot => fridays_at_9.time_slot.to_query).first

    assert_nil(read_rule_1)
    assert_not_nil(read_rule_2)
    assert_equal(fridays_at_9.time_slot, read_rule_2.time_slot)
  end

end