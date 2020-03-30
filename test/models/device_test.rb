require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  test "serial numbers are unique" do
    serial_number = "AB1234"

    Device.create!(serial_number: serial_number)

    device2 = Device.new(serial_number: serial_number)

    refute device2.valid?

    assert_raise ActiveRecord::RecordNotUnique do
      device2.save!(validate: false)
    end
  end
end
