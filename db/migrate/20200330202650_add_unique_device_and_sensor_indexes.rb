class AddUniqueDeviceAndSensorIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :devices, :serial_number, unique: true
    add_index :sensors, [:device_id, :sensor_number], unique: true
  end
end
