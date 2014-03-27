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

ActiveRecord::Schema.define(version: 20140309205036) do

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
    t.string   "downtimeType"
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
    t.string   "month"
    t.integer  "year"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
