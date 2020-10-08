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

ActiveRecord::Schema.define(version: 2020_10_08_201245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artwork_shares", force: :cascade do |t|
    t.bigint "artwork_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "viewer_id"
    t.index ["artwork_id"], name: "index_artwork_shares_on_artwork_id"
    t.index ["viewer_id"], name: "index_artwork_shares_on_viewer_id"
  end

  create_table "artworks", force: :cascade do |t|
    t.string "title"
    t.string "image_url"
    t.bigint "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_artworks_on_artist_id"
    t.index ["title", "artist_id"], name: "index_artworks_on_title_and_artist_id", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.string "body", null: false
    t.bigint "author_id"
    t.bigint "artwork_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artwork_id"], name: "index_comments_on_artwork_id"
    t.index ["author_id"], name: "index_comments_on_author_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "artwork_shares", "artworks"
  add_foreign_key "artwork_shares", "users", column: "viewer_id"
  add_foreign_key "artworks", "users", column: "artist_id"
  add_foreign_key "comments", "artworks"
  add_foreign_key "comments", "users", column: "author_id"
end
