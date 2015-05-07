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

ActiveRecord::Schema.define(version: 20150507120516) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contents", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.datetime "release_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "status"
    t.string   "on_server_id"
    t.integer  "podcast_id"
  end

  add_index "contents", ["podcast_id"], name: "index_contents_on_podcast_id", using: :btree

  create_table "podcasts", force: :cascade do |t|
    t.string   "title"
    t.string   "rss_link"
    t.datetime "last_check"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name",            limit: 20, null: false
    t.string "password_digest",            null: false
    t.string "email",                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

  create_table "users_contents", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "content_id"
  end

  add_index "users_contents", ["content_id"], name: "index_users_contents_on_content_id", using: :btree
  add_index "users_contents", ["user_id"], name: "index_users_contents_on_user_id", using: :btree

  create_table "users_podcasts", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "podcast_id"
  end

  add_index "users_podcasts", ["podcast_id"], name: "index_users_podcasts_on_podcast_id", using: :btree
  add_index "users_podcasts", ["user_id"], name: "index_users_podcasts_on_user_id", using: :btree

end
