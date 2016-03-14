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

ActiveRecord::Schema.define(version: 20160314040002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feedbacks", force: :cascade do |t|
    t.integer "state"
  end

  create_table "g_files", force: :cascade do |t|
    t.string "name"
  end

  add_index "g_files", ["name"], name: "index_g_files_on_name", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.integer "ghid"
    t.boolean "enabled"
    t.string  "secret_key"
  end

  add_index "repositories", ["ghid"], name: "index_repositories_on_ghid", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer "pr"
    t.integer "state"
  end

  add_index "reviews", ["pr"], name: "index_reviews_on_pr", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "nickname"
    t.string  "token"
    t.integer "ghuid"
  end

  add_index "users", ["ghuid"], name: "index_users_on_ghuid", using: :btree

end
