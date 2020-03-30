require 'test_helper'

class SensorTest < ActiveSupport::TestCase
  test "sensor numbers are unique scoped to a device" do
    sensor_number = "42"
    device1 = Device.create!(serial_number: "A")
    device2 = Device.create!(serial_number: "B")

    sensor1 = Sensor.create!(device: device1, sensor_number: sensor_number)
    sensor2 = Sensor.new(device: device1, sensor_number: sensor_number)
    sensor3 = Sensor.new(device: device2, sensor_number: sensor_number)

    refute sensor2.valid?
    assert sensor3.valid?

    assert_raise ActiveRecord::RecordNotUnique do
      sensor2.save!(validate: false)
    end

    assert_raise ActiveRecord::RecordNotUnique do
      sensor2.save!(validate: false)
    end

    assert sensor3.save!
  end
end
