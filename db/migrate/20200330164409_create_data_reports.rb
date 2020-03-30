class CreateDataReports < ActiveRecord::Migration[6.0]
  def change
    create_table :data_reports do |t|
      t.text :data

      t.timestamps
    end
  end
end
