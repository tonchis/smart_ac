class CreateReadings < ActiveRecord::Migration[6.0]
  def change
    create_table :readings do |t|
      t.references :sensor, null: false, foreign_key: true
      t.decimal :temperature
      t.integer :humidity
      t.integer :carbon_monoxide
      t.string :health_status
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
