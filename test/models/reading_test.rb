require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  test "creates a reading from data" do
    time = Time.now

    data = {
      temperature: "123.456",
      humidity: 78,
      carbon_monoxide: 3,
      health_status: "healthy",
      recorded_at: time.iso8601
    }

    reading = Reading.new(data)

    assert reading.recorded_at.to_i == time.to_i
    assert reading.recorded_at.kind_of?(Time)

    assert reading.humidity == 78
    assert reading.temperature == 123.456
    assert reading.carbon_monoxide == 3
  end

  test "creates an alert if the carbon monoxide is too high" do
    time = Time.now

    data = {
      temperature: "123.456",
      humidity: 78,
      carbon_monoxide: 12,
      health_status: "healthy",
      recorded_at: time.iso8601
    }

    device = Device.create!(serial_number: "A")
    sensor = Sensor.create!(device: device, sensor_number: "1")

    reading = sensor.readings.new(data)

    reading.save

    assert reading.persisted?
    alert = sensor.alert

    assert alert.present?

    assert alert.carbon_monoxide_high?
    assert alert.active?
  end


  test "creates an alert if the sensor needs service" do
    time = Time.now

    data = {
      temperature: "123.456",
      humidity: 78,
      carbon_monoxide: 2,
      health_status: "needs_service",
      recorded_at: time.iso8601
    }

    device = Device.create!(serial_number: "A")
    sensor = Sensor.create!(device: device, sensor_number: "1")

    reading = sensor.readings.new(data)

    reading.save

    assert reading.persisted?
    alert = sensor.alert

    assert alert.present?

    assert alert.needs_service?
    assert alert.active?
  end


  test "creates an alert if the carbon monoxide is too high and the sensor needs service" do
    time = Time.now

    data = {
      temperature: "123.456",
      humidity: 78,
      carbon_monoxide: 12,
      health_status: "gas_leak",
      recorded_at: time.iso8601
    }

    device = Device.create!(serial_number: "A")
    sensor = Sensor.create!(device: device, sensor_number: "1")

    reading = sensor.readings.new(data)

    reading.save

    assert reading.persisted?
    alert = sensor.alert

    assert alert.present?

    assert alert.carbon_monoxide_high?
    assert alert.gas_leak?

    assert alert.active?
  end
end
