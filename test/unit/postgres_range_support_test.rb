require "test_helper"
require "#{Rails.root.to_s}/lib/postgres_range_support"

class PostgresRangeSupportTest < ActiveSupport::TestCase

  test "can parse Postgres ranges into Ruby ranges" do
    pg_range = "[2014-01-20T06:00:00-08:00,2014-01-20T06:59:59-08:00]"
    range = RangeSupport.string_to_range(pg_range)
    start_time = DateTime.parse("2014-01-20T06:00:00-08:00")
    end_time = DateTime.parse("2014-01-20T06:59:59-08:00")
    assert_equal(DateTimeRange.new(start_time, end_time), range)
  end

  test "can parse Postgres ranges into Ruby ranges two" do
    pg_range = "[\"2014-01-22 17:00:00+00\",\"2014-01-22 17:59:59+00\"]"
    range = RangeSupport.string_to_range(pg_range)
    start_time = DateTime.parse("2014-01-22T17:00:00+00")
    end_time = DateTime.parse("2014-01-22T17:59:59+00")
    puts range
    assert_equal(DateTimeRange.new(start_time, end_time), range)
  end
end
