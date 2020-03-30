require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  test "creates a reading from data" do
    time = Time.now

    data = {
      temperature: "123.456",
      humidity: 78,
      carbon_monoxide: 12,
      health_status: "healthy",
      recorded_at: time.iso8601
    }

    reading = Reading.new(data)

    assert reading.recorded_at.to_i == time.to_i
    assert reading.recorded_at.kind_of?(Time)

    assert reading.humidity == 78
    assert reading.temperature == 123.456
    assert reading.carbon_monoxide == 12
  end
end
