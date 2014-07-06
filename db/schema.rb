# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140616210650) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.boolean  "is_counselling"
    t.float    "requirement"
    t.boolean  "max"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: true do |t|
    t.integer  "user_id"
    t.integer  "site_id"
    t.string   "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.boolean  "is_default_site"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcategories", force: true do |t|
    t.integer  "category_id"
    t.boolean  "max"
    t.string   "name"
    t.float    "requirement"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supervisors", force: true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "license_state"
    t.string   "license_type"
    t.string   "license_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_passwords", force: true do |t|
    t.string   "uuid"
    t.string   "hashed_uuid"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_hours", force: true do |t|
    t.integer  "entry_id"
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.float    "recorded_hours"
    t.float    "valid_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "grad_date"
    t.string   "email",      limit: 100
    t.string   "password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
