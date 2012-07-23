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

ActiveRecord::Schema.define(:version => 20120722101906) do

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
    t.integer  "user_id"
    t.integer  "english_first_language"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "gender"
  end

  create_table "user_words", :force => true do |t|
    t.integer  "user_id"
    t.integer  "word_id"
    t.boolean  "new"
    t.float    "interval"
    t.datetime "last_review"
    t.datetime "next_due"
    t.integer  "incorrect_count"
    t.integer  "correct_count"
    t.float    "easiness_factor"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "user_words", ["user_id"], :name => "index_user_words_on_user_id"
  add_index "user_words", ["word_id"], :name => "index_user_words_on_word_id"

  create_table "users", :force => true do |t|
    t.string   "registration_code"
    t.datetime "last_login"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "password_digest"
    t.string   "email"
    t.string   "role"
  end

  create_table "words", :force => true do |t|
    t.string   "expression"
    t.string   "reading"
    t.string   "meaning"
    t.float    "average_easiness_factor"
    t.integer  "reviewed_count"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "type1"
    t.string   "type2"
    t.boolean  "honorific"
    t.integer  "order"
  end

end
