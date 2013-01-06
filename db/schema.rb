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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130105191340) do

  create_table "ArbuckleGroup", :primary_key => "groupID", :force => true do |t|
    t.integer "typeID",                  :null => false
    t.string  "groupName", :limit => 36, :null => false
    t.float   "Price"
    t.string  "Detail",    :limit => 68, :null => false
  end

  create_table "ArbuckleItem", :primary_key => "itemID", :force => true do |t|
    t.integer "groupID",                   :null => false
    t.string  "itemName",    :limit => 36, :null => false
    t.float   "Price"
    t.boolean "ComboSubset",               :null => false
    t.string  "Detail",      :limit => 68, :null => false
    t.string  "Spicy",       :limit => 11, :null => false
  end

  create_table "ArbuckleOrderDetails", :primary_key => "DetailID", :force => true do |t|
    t.integer "OrderID",  :null => false
    t.integer "typeID",   :null => false
    t.integer "groupID",  :null => false
    t.integer "itemID",   :null => false
    t.integer "Quantity", :null => false
    t.boolean "Spicy",    :null => false
  end

  create_table "ArbuckleOrderList", :primary_key => "orderID", :force => true do |t|
    t.integer "UserID",                   :null => false
    t.date    "Order Date",               :null => false
    t.date    "DUE DATE",                 :null => false
    t.string  "Day",        :limit => 36, :null => false
    t.time    "Time",                     :null => false
    t.boolean "Blocked",                  :null => false
    t.integer "Filled",                   :null => false
  end

  create_table "ArbuckleType", :primary_key => "typeID", :force => true do |t|
    t.string "typeName", :limit => 36, :null => false
    t.float  "Price"
  end

  create_table "ArbuckleUserList", :primary_key => "userID", :force => true do |t|
    t.string  "UserName",   :limit => 36,                    :null => false
    t.string  "first_name", :limit => 48, :default => ""
    t.string  "last_name",  :limit => 48, :default => ""
    t.string  "e_mail",     :limit => 48, :default => ""
    t.boolean "just_sent",                :default => false
  end

  create_table "groups", :force => true do |t|
    t.integer  "typeID"
    t.string   "groupName"
    t.decimal  "Price",      :precision => 10, :scale => 0
    t.string   "Detail"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "groups", ["typeID"], :name => "index_groups_on_typeID"

  create_table "items", :force => true do |t|
    t.integer  "groupID"
    t.string   "itemName"
    t.decimal  "Price",       :precision => 10, :scale => 0
    t.boolean  "ComboSubset"
    t.string   "Detail"
    t.string   "Spicy"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "items", ["groupID"], :name => "index_items_on_groupID"

  create_table "order_details", :force => true do |t|
    t.integer "orderID"
    t.integer "typeID"
    t.integer "groupID"
    t.integer "itemID"
    t.integer "quantity"
    t.boolean "spicy"
  end

  add_index "order_details", ["orderID"], :name => "index_order_details_on_orderID"

  create_table "orders", :force => true do |t|
    t.integer  "userID",                        :null => false
    t.date     "date",                          :null => false
    t.date     "due",                           :null => false
    t.string   "day",        :default => ""
    t.datetime "time",                          :null => false
    t.boolean  "blocked",    :default => false, :null => false
    t.integer  "filled",     :default => 0,     :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "types", :force => true do |t|
    t.string   "typeName"
    t.decimal  "Price",      :precision => 10, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "UserName"
    t.string   "first_name", :default => ""
    t.string   "last_name",  :default => ""
    t.string   "e_mail",     :default => ""
    t.integer  "just_sent",  :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

end
