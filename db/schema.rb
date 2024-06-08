# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_08_082247) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daily_records", force: :cascade do |t|
    t.date "date"
    t.integer "male_count", default: 0
    t.integer "female_count", default: 0
    t.float "male_avg_age", default: 0.0
    t.float "female_avg_age", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_daily_records_on_date"
    t.index ["female_count"], name: "index_daily_records_on_female_count"
    t.index ["male_count"], name: "index_daily_records_on_male_count"
  end

  create_table "users", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "gender"
    t.jsonb "name"
    t.jsonb "location"
    t.integer "age", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
