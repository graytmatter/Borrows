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

ActiveRecord::Schema.define(version: 20140617012511) do

  create_table "inventories", force: true do |t|
    t.string   "item_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventories", ["item_name"], name: "index_inventories_on_item_name"

  create_table "requests", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "items",          limit: 255
    t.string   "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "edit_id"
    t.string   "rentdate"
    t.boolean  "paydeliver"
    t.string   "addysdeliver"
    t.string   "timedeliver"
    t.string   "instrucdeliver"
    t.string   "heard"
    t.datetime "startdate"
    t.datetime "enddate"
    t.integer  "user_id"
    t.boolean  "tos_agree"
  end

  create_table "signups", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "heard"
    t.string   "streetone"
    t.string   "streettwo"
    t.integer  "zipcode"
  end

  add_index "signups", ["email"], name: "index_signups_on_email", unique: true

  create_table "transactions", force: true do |t|
    t.integer  "request_id"
    t.integer  "item_id"
    t.string   "name"
    t.datetime "startdate"
    t.datetime "enddate"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["enddate"], name: "index_transactions_on_enddate"
  add_index "transactions", ["startdate"], name: "index_transactions_on_startdate"

end
