require 'test_helper'

class RandomTimeSeriesValueTest < ActiveSupport::TestCase
  test "iterates a value" do
    previous_val = RandomTimeSeriesValue.new(
      Time.now - 1.year,
      0.177,
      2,
      18.0,
      25.0,
      0
    )
    val = RandomTimeSeriesValue.from(previous_val)

    val.value 

    assert val.time == previous_val.time + 1.minute
    assert_in_delta(21.5, val.value, 5.5)
  end

  test "creates a time series for a day" do
    array = RandomTimeSeriesValue.array(24 * 60, Time.now - 1.year, 0.177, 2, 18.0, 25.0)
    assert array.length == (24 * 60)
  end

  test "creates a time series for a year" do
    array = RandomTimeSeriesValue.array(365 * 3, Time.now - 1.year, 0.177, 2, 18.0, 25.0, 8.hours)
    assert array.length == (365 * 3)
  end

end
