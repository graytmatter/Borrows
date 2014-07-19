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

ActiveRecord::Schema.define(version: 20140719201034) do

  create_table "borrows", force: true do |t|
    t.integer  "request_id"
    t.string   "name"
    t.integer  "status1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "itemlist_id"
    t.integer  "status2"
    t.integer  "inventory_id"
  end

  add_index "borrows", ["name"], name: "index_borrows_on_name"
  add_index "borrows", ["request_id"], name: "index_borrows_on_request_id"

  create_table "categorylists", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorylists", ["name"], name: "index_categorylists_on_name", unique: true

  create_table "inventories", force: true do |t|
    t.string   "item_name"
    t.integer  "signup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description", limit: 255
    t.integer  "itemlist_id"
  end

  add_index "inventories", ["item_name"], name: "index_inventories_on_item_name"
  add_index "inventories", ["signup_id"], name: "index_inventories_on_signup_id"

  create_table "itemlists", force: true do |t|
    t.string   "name"
    t.boolean  "request_list"
    t.boolean  "inventory_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "categorylist_id"
  end

  add_index "itemlists", ["name"], name: "index_itemlists_on_name", unique: true

  create_table "requests", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "items",      limit: 255
    t.text     "detail",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "edit_id"
    t.string   "heard"
    t.datetime "pickupdate"
    t.datetime "returndate"
    t.integer  "signup_id"
  end

  add_index "requests", ["pickupdate"], name: "index_requests_on_pickupdate"
  add_index "requests", ["returndate"], name: "index_requests_on_returndate"
  add_index "requests", ["signup_id"], name: "index_requests_on_signup_id"

  create_table "signups", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "heard"
    t.string   "streetone"
    t.string   "streettwo"
    t.string   "zipcode"
    t.boolean  "tos"
  end

  add_index "signups", ["email"], name: "index_signups_on_email", unique: true

  create_table "statuscategories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuscategories", ["name"], name: "index_statuscategories_on_name", unique: true

  create_table "statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "statuscategory_id"
  end

  add_index "statuses", ["name"], name: "index_statuses_on_name", unique: true

end
