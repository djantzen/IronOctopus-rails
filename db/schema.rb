# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120122034545) do

  create_table "activities", :primary_key => "activity_id", :force => true do |t|
    t.text     "name",             :null => false
    t.integer  "activity_type_id", :null => false
    t.integer  "creator_id",       :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "activity_sets", :id => false, :force => true do |t|
    t.integer "routine_id",                        :null => false
    t.integer "activity_id",                       :null => false
    t.integer "measurement_id",                    :null => false
    t.float   "position",       :default => 1.0,   :null => false
    t.boolean "optional",       :default => false, :null => false
  end

  add_index "activity_sets", ["routine_id", "position"], :name => "activity_sets_uniq_idx_routine_id_position", :unique => true

  create_table "activity_types", :primary_key => "activity_type_id", :force => true do |t|
    t.text "name", :null => false
  end

  add_index "activity_types", ["name"], :name => "activity_types_uniq_idx_name", :unique => true

  create_table "days", :id => false, :force => true do |t|
    t.integer  "day_id",     :null => false
    t.date     "full_date",  :null => false
    t.integer  "year",       :null => false
    t.integer  "month",      :null => false
    t.integer  "day",        :null => false
    t.datetime "created_at"
  end

  add_index "days", ["day", "month", "year"], :name => "days_idx_year_month_day", :unique => true
  add_index "days", ["full_date"], :name => "days_idx_full_date", :unique => true

  create_table "measurements", :primary_key => "measurement_id", :force => true do |t|
    t.integer  "duration",           :default => 0,   :null => false
    t.float    "resistance",         :default => 0.0, :null => false
    t.integer  "repetitions",        :default => 1,   :null => false
    t.float    "pace",               :default => 0.0, :null => false
    t.float    "distance",           :default => 0.0, :null => false
    t.integer  "calories",           :default => 0,   :null => false
    t.integer  "distance_unit_id",   :default => 0,   :null => false
    t.integer  "resistance_unit_id", :default => 0,   :null => false
    t.integer  "pace_unit_id",       :default => 0,   :null => false
    t.datetime "created_at",                          :null => false
  end

  add_index "measurements", ["duration", "resistance", "repetitions", "pace", "distance", "calories", "distance_unit_id", "resistance_unit_id", "pace_unit_id"], :name => "measurement_uniq_idx", :unique => true

  create_table "routines", :primary_key => "routine_id", :force => true do |t|
    t.text     "name",       :default => "Routine", :null => false
    t.integer  "owner_id",                          :null => false
    t.integer  "creator_id",                        :null => false
    t.text     "goal",       :default => "None",    :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "routines", ["owner_id"], :name => "routines_uniq_idx_owner_name", :unique => true

  create_table "units", :primary_key => "unit_id", :force => true do |t|
    t.text "name", :null => false
    t.text "abbr", :null => false
  end

  create_table "users", :primary_key => "user_id", :force => true do |t|
    t.text     "login",      :null => false
    t.text     "email",      :null => false
    t.text     "password",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "work", :id => false, :force => true do |t|
    t.integer  "user_id",        :null => false
    t.integer  "routine_id",     :null => false
    t.integer  "activity_id",    :null => false
    t.integer  "measurement_id", :null => false
    t.datetime "start_time",     :null => false
    t.datetime "end_time",       :null => false
    t.integer  "start_day_id",   :null => false
  end

end
