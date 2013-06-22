require 'test_helper'

class UnitTest < ActiveSupport::TestCase

  test "kilometers to meters" do
    meters = Unit.convert_to_meters(1, "Kilometer")
    assert_equal(1000, meters)
  end

  test "meters to kilometers" do
    km = Unit.convert_from_meters(1000, "Kilometer")
    assert_equal(1, km)
  end

  test "yards to meters" do
    meters = Unit.convert_to_meters(1, "Yard")
    assert_equal(0.9144, meters)
  end

  test "meters to yards" do
    km = Unit.convert_from_meters(1, "Yard")
    assert_equal(1.09361, km)
  end

  test "miles to meters" do
    meters = Unit.convert_to_meters(1, "Mile")
    assert_equal(1609.344, meters)
  end

  test "meters to miles" do
    miles = Unit.convert_from_meters(1609.344, "Mile")
    assert_equal(1, miles)
  end

  test "miles to meters to miles" do
    miles = 13
    assert_equal(miles, Unit.convert_from_meters(Unit.convert_to_meters(miles, "Mile"), "Mile"))
  end

end
