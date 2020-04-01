# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

device_configs = [
  {serial_number: "FAKE-123-01", sensors: 2},
  {serial_number: "FAKE-123-02", sensors: 2},
  {serial_number: "FAKE-123-03", sensors: 2}
]

Device.transaction do 
  sensors = []

  devices = device_configs.map do |d|
    Device.find_or_create_by!(serial_number: d[:serial_number]) do |device|
      device.sensors = d[:sensors].times.map do |n|
        sensor = Sensor.new(sensor_number: n.to_s)
        sensors << sensor
        sensor
      end
      device.registration_date = (Time.now - 1.year).to_date
      device.firmware_version = "1.2.3"
    end
  end
  
  sensors.each do |sensor|
    SampleSensorReadings.create(sensor, 24 * 60, 1.minute, (Time.zone.today - 1.day).midnight) 
    SampleSensorReadings.create(sensor, 24 * 2 * 6, 30.minutes, (Time.zone.today - 2.days).midnight)
    SampleSensorReadings.create(sensor, 358 * 3, 8.hours, initial_time = (Time.zone.today - 7.days).midnight)
  end
end
