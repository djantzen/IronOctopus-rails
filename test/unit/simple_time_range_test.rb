require 'test_helper'

class SimpleTimeRangeTest < ActiveSupport::TestCase

  test "to identifier works" do
    from = SimpleTime.new(12, 0, 0)
    to = SimpleTime.new(12, 59, 59)
    str = SimpleTimeRange.new(from, to)
    assert_equal("from-12:00:00-to-12:59:59", str.to_identifier)
  end

  test "from identifier works" do
    from = SimpleTime.new(12, 0, 0)
    to = SimpleTime.new(12, 59, 59)
    str = SimpleTimeRange.new(from, to)
    assert_equal(str, SimpleTimeRange.from_identifier("from-12:00:00-to-12:59:59"))
  end

  test "to_query generates a postgres range" do
    from = SimpleTime.new(12, 0, 0)
    to = SimpleTime.new(12, 59, 59)
    str = SimpleTimeRange.new(from, to)
    assert_equal("[\"12:00:00\",\"12:59:59\"]", str.to_query)
  end


end
