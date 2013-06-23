require 'test_helper'

class UnitTest < ActiveSupport::TestCase

  test "kilometers to meters" do
    meters = Unit.kilometers_to_meters(1)
    assert_equal(1000, meters)
  end

  test "meters to kilometers" do
    km = Unit.meters_to_kilometers(1000)
    assert_equal(1, km)
  end

  test "yards to meters" do
    meters = Unit.yards_to_meters(1)
    assert_equal(0.9144, meters)
  end

  test "meters to yards" do
    km = Unit.meters_to_yards(1)
    assert_equal(1.09361, km)
  end

  test "miles to meters" do
    meters = Unit.miles_to_meters(1)
    assert_equal(1609.344, meters)
  end

  test "meters to miles" do
    miles = Unit.meters_to_miles(1609.344)
    assert_equal(0.9999996906240001, miles)
  end

  test "pounds to kilograms" do
    kilograms = Unit.pounds_to_kilograms(1)
    assert_equal(0.453592, kilograms)
  end

  test "kilograms to pounds" do
    pounds = Unit.kilograms_to_pounds(1)
    assert_equal(2.20462, pounds)
  end

  test "miles to kilometers per hour" do
    kph = Unit.mph_to_kph(100)
    assert_equal(160.934, kph)
  end

  test "kilometers to miles per hour" do
    mph = Unit.kph_to_mph(100)
    assert_equal(62.137100000000004, mph)
  end

  test "digital to seconds" do
    digital = "1:39"
    assert_equal(99, Unit.digital_to_seconds(digital))
  end

  test "seconds to digital" do
    seconds = 99
    assert_equal("1:39", Unit.seconds_to_digital(seconds))
  end

  test "miles to meters to miles" do
    miles = 100
    meters = Unit.convert_to_meters(miles, Unit::MILE)
    assert_equal(miles, Unit.convert_from_meters(meters, Unit::MILE))
  end

  #test "yards to meters to yards" do
  #  yards = 100
  #  meters = Unit.convert_to_meters(yards, "Mile")
  #  assert_equal(yards, Unit.convert_from_meters(meters, "Mile"))
  #end

  test "pounds to kilograms to pounds" do
    pounds = 100
    kilograms = Unit.convert_to_kilograms(pounds, Unit::POUND)
    assert_equal(pounds, Unit.convert_from_kilograms(kilograms, Unit::POUND))
  end

  test "mph to kph to mph" do
    mph = 100
    kph = Unit.convert_to_kilometers_per_hour(mph, Unit::MILES_PER_HOUR)
    assert_equal(mph, Unit.convert_from_kilometers_per_hour(kph, Unit::MILES_PER_HOUR))
  end

end
