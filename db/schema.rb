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

ActiveRecord::Schema.define(version: 20140214154155) do

  create_table "networks", force: true do |t|
    t.string   "fb_id"
    t.string   "name"
    t.integer  "fb_fans"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "kind"
    t.text     "copy"
    t.integer  "likes"
    t.integer  "comments"
    t.integer  "shares"
    t.datetime "date"
    t.string   "link"
    t.string   "fb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "network_id"
    t.float    "engagement"
  end

end
