require 'test_helper'

class DateTimeRangeTest < ActiveSupport::TestCase

  test "to identifier works in PST" do
    Time.zone = "America/Los_Angeles"
    from = Time.new(2013, 1, 1, 12, 0, 0).to_datetime
    to = Time.new(2013, 1, 1, 12, 59, 59).to_datetime
    dtr = DateTimeRange.new(from, to)
    assert_equal("from-2013-01-01_12:00:00-08:00-to-2013-01-01_12:59:59-08:00", dtr.to_identifier)
  end

  test "to identifier works in PDT" do
    Time.zone = "America/Los_Angeles"
    from = Time.new(2013, 6, 1, 12, 0, 0).to_datetime
    to = Time.new(2013, 6, 1, 12, 59, 59).to_datetime
    dtr = DateTimeRange.new(from, to)
    assert_equal("from-2013-06-01_12:00:00-07:00-to-2013-06-01_12:59:59-07:00", dtr.to_identifier)
  end

  test "from identifier works in PST" do
    Time.zone = "America/Los_Angeles"
    from = Time.new(2013, 1, 1, 12, 0, 0).to_datetime
    to = Time.new(2013, 1, 1, 12, 59, 59).to_datetime
    dtr = DateTimeRange.new(from, to)
    assert_equal(dtr, DateTimeRange.from_identifier("from-2013-01-01_12:00:00-08:00-to-2013-01-01_12:59:59-08:00"))
  end

  test "to_query generates a postgres range" do
    Time.zone = "America/Los_Angeles"
    from = Time.new(2013, 9, 4, 12, 0, 0).to_datetime
    to = Time.new(2013, 9, 4, 13, 59, 59).to_datetime
    dtr = DateTimeRange.new(from, to)
    assert_equal("[\"2013-09-04T12:00:00-07:00\",\"2013-09-04T13:59:59-07:00\")", dtr.to_query)
  end


end
