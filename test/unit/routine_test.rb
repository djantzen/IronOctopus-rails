require 'test_helper'

class RoutineTest < ActiveSupport::TestCase

  test "ActivitySetGroups are deleted when parent Routine is deleted" do
    r = Routine.create(:name => "nothin'", :client => User.first, :trainer => User.first)
    g = ActivitySetGroup.new()
    r.activity_set_groups << g
    g.activity_sets << ActivitySet.new(:activity => Activity.first, :measurement => Measurement.first, :unit_set => UnitSet.first)
    r.destroy
  end

  test "RoutineDateTimeSlots are deleted when parent Routine is deleted" do
    r = Routine.create(:name => "nothin'", :client => User.first, :trainer => User.first)
    r.routine_date_time_slots << RoutineDateTimeSlot.new(:date_time_slot => DateTimeRange.new(DateTime.now, DateTime.now))
    r.destroy
  end

end