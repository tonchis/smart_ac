class CreateSensors < ActiveRecord::Migration[6.0]
  def change
    create_table :sensors do |t|
      t.references :device, null: false, foreign_key: true
      t.string :sensor_number

      t.timestamps
    end
  end
end
