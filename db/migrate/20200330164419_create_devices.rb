class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :serial_number
      t.string :registration_date
      t.string :firmware_version

      t.timestamps
    end
  end
end
