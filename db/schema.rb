# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_01_030100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_reports", force: :cascade do |t|
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string "serial_number"
    t.string "registration_date"
    t.string "firmware_version"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["serial_number"], name: "index_devices_on_serial_number", unique: true
  end

  create_table "readings", force: :cascade do |t|
    t.bigint "sensor_id", null: false
    t.decimal "temperature", precision: 8, scale: 3
    t.integer "humidity"
    t.integer "carbon_monoxide"
    t.string "health_status"
    t.datetime "recorded_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sensor_id"], name: "index_readings_on_sensor_id"
  end

  create_table "sensors", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.string "sensor_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id", "sensor_number"], name: "index_sensors_on_device_id_and_sensor_number", unique: true
    t.index ["device_id"], name: "index_sensors_on_device_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "readings", "sensors"
  add_foreign_key "sensors", "devices"
end
