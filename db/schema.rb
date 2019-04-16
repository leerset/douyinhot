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

ActiveRecord::Schema.define(version: 2019_04_16_023246) do

  create_table "api_manages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "api_name"
    t.integer "manage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "apps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "app_name"
    t.string "app_id"
    t.string "app_key"
    t.string "app_secret"
    t.string "firm_name"
    t.string "paltform"
    t.datetime "registration_time"
    t.integer "status"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_apps_on_app_id"
    t.index ["app_name"], name: "index_apps_on_app_name"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "category_number"
    t.string "category_name", null: false
    t.bigint "group_id", null: false
    t.string "image_url"
    t.string "standard"
    t.string "unit"
    t.integer "group_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_number"], name: "index_categories_on_category_number"
    t.index ["group_id"], name: "index_categories_on_group_id"
  end

  create_table "category_formula_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "category_formula_id"
    t.integer "category_number"
    t.string "formula"
    t.integer "top_limit"
    t.integer "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_formula_id"], name: "index_category_formula_histories_on_category_formula_id"
    t.index ["category_number"], name: "index_category_formula_histories_on_category_number"
  end

  create_table "category_formulas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "category_number"
    t.string "formula"
    t.integer "top_limit"
    t.integer "version", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_number"], name: "index_category_formulas_on_category_number"
  end

  create_table "category_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "id_code"
    t.string "app_id"
    t.bigint "user_id"
    t.datetime "request_time"
    t.integer "request_status"
    t.integer "release_status"
    t.string "request_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "appuser_id"
    t.index ["app_id"], name: "index_category_requests_on_app_id"
    t.index ["user_id"], name: "index_category_requests_on_user_id"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "group_name"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_groups_on_group_id"
  end

  create_table "resolution_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "id_code"
    t.string "plain_code"
    t.string "app_id"
    t.bigint "user_id"
    t.integer "category_number"
    t.string "sample_value"
    t.string "gps"
    t.datetime "sample_time"
    t.string "resolution_result"
    t.integer "formula_version"
    t.string "hardware_id"
    t.string "request_ip"
    t.integer "return_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hardware_version"
    t.string "software_version"
    t.string "firm_name"
    t.string "model_number"
    t.string "appuser_id"
    t.index ["app_id"], name: "index_resolution_requests_on_app_id"
    t.index ["user_id"], name: "index_resolution_requests_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name", default: "管理员", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
