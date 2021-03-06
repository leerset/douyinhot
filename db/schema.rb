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

ActiveRecord::Schema.define(version: 2022_06_27_084521) do

  create_table "douyin_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.string "url"
    t.integer "hot_threshold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kaogu_productions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.integer "rank"
    t.string "name"
    t.string "link"
    t.string "imageUrl"
    t.string "nowPrice"
    t.string "oldPrice"
    t.string "commissionRate"
    t.string "videSales"
    t.string "views"
    t.string "videoCount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "sales", precision: 10, scale: 2, default: "0.0", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name", default: "?????????", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "douyin_account_id"
    t.string "name"
    t.string "number"
    t.string "tag"
    t.string "url"
    t.integer "like"
    t.integer "comment"
    t.integer "attention"
    t.datetime "release_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["douyin_account_id"], name: "index_videos_on_douyin_account_id"
  end

end
