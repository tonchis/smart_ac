class AddScaleToDecimalFields < ActiveRecord::Migration[6.0]
  def change
    change_column :readings, :temperature, :decimal, precision: 8, scale: 3
  end
end
