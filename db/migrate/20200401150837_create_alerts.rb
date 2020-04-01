class CreateAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.references :sensor, index: {:unique=>true}, null: false, foreign_key: true
      t.boolean :active
      t.boolean :carbon_monoxide_high
      t.boolean :needs_service
      t.boolean :needs_new_filter
      t.boolean :gas_leak

      t.timestamps
    end
  end
end
