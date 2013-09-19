require 'test_helper'

class ProgramTest < ActiveSupport::TestCase

  def test_weekday_program_for_jim_the_client_shows_olympic_lift_2_is_today
    client = User.find_by_login("jim_the_client")
    assert_equal(0, client.todays_routines.size)
    trainer = User.find_by_login("mary_the_trainer")
    routine1 = Routine.find_by_name("Olympic Lift Training 1")
    routine2 = Routine.find_by_name("Olympic Lift Training 2")
    routine3 = Routine.find_by_name("Olympic Lift Training 3")

    program = Program.new(:name => 'Olympic Lifting Weekday', :goal => 'Herculean awesomeness',
                          :client => client, :trainer => trainer)
    program.save

    weekday_program_yesterday = WeekdayProgram.new(:routine => routine1, :program => program,
                                                   :day_of_week => (client.local_time.to_date - 1.day).strftime("%A"))
    weekday_program_yesterday.save
    assert_equal(0, client.reload.todays_routines.size)
    weekday_program_today = WeekdayProgram.new(:routine => routine2, :program => program,
                                               :day_of_week => client.local_time.to_date.strftime("%A"))
    weekday_program_today.save
    assert_equal(1, client.reload.todays_routines.size)
    assert_equal("Olympic Lift Training 2", User.find_by_login("jim_the_client").todays_routines.first.name)

    weekday_program_tomorrow = WeekdayProgram.new(:routine => routine3, :program => program,
                                                  :day_of_week => (Time.zone.today + 1.day).strftime("%A"))
    weekday_program_tomorrow.save
    assert_equal(1, client.reload.todays_routines.size)
    assert_equal("Olympic Lift Training 2", User.find_by_login("jim_the_client").todays_routines.first.name)

  end

  def test_scheduled_program_for_jim_the_client_shows_olympic_lift_2_is_today
    client = User.find_by_login("jim_the_client")
    assert_equal(0, client.todays_routines.size)
    trainer = User.find_by_login("mary_the_trainer")
    routine1 = Routine.find_by_name("Olympic Lift Training 1")
    routine2 = Routine.find_by_name("Olympic Lift Training 2")
    routine3 = Routine.find_by_name("Olympic Lift Training 3")

    program = Program.new(:name => 'Olympic Lifting Scheduled', :goal => 'Herculean awesomeness',
                          :client => client, :trainer => trainer)
    program.save
    scheduled_program_yesterday = ScheduledProgram.new(:routine => routine1, :program => program,
                                                       :scheduled_on => client.local_time.to_date - 1.day)
    scheduled_program_yesterday.save
    assert_equal(0, client.reload.todays_routines.size)

    scheduled_program_today = ScheduledProgram.new(:routine => routine2, :program => program,
                                                   :scheduled_on => client.local_time.to_date)
    scheduled_program_today.save
    assert_equal(1, client.reload.todays_routines.size)
    assert_equal("Olympic Lift Training 2", User.find_by_login("jim_the_client").todays_routines.first.name)

    scheduled_program_today = ScheduledProgram.new(:routine => routine3, :program => program,
                                                   :scheduled_on => Time.zone.today + 1.day)
    scheduled_program_today.save
    assert_equal(1, client.reload.todays_routines.size)
    assert_equal("Olympic Lift Training 2", User.find_by_login("jim_the_client").todays_routines.first.name)
  end

end
