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

ActiveRecord::Schema.define(:version => 20120715042319) do

  create_table "registration_codes", :force => true do |t|
    t.string   "code"
    t.string   "role"
    t.boolean  "used"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "printed"
    t.string   "tag"
  end

  create_table "user_infos", :force => true do |t|
    t.integer  "user_id_id"
    t.integer  "gender"
    t.integer  "english_first_language"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_code"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "password_reset"
    t.integer  "user_type"
    t.datetime "last_login"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end