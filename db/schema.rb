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

ActiveRecord::Schema.define(version: 20140408111002) do

  create_table "customer_configurations", force: true do |t|
    t.integer  "customer_id"
    t.time     "dailySlaStart"
    t.time     "dailySlaEnd"
    t.text     "weeklySlaDays"
    t.text     "excludedDays"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "downtimes", force: true do |t|
    t.datetime "start"
    t.string   "downtime_type"
    t.datetime "end"
    t.string   "comment"
    t.integer  "sla_per_day_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sla_per_days", force: true do |t|
    t.integer  "day"
    t.integer  "sla_per_month_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sla_per_months", force: true do |t|
    t.integer  "month"
    t.integer  "year"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
