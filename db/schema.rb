# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_04_052312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_sessions", force: :cascade do |t|
    t.string "uuid", null: false
    t.datetime "expire_date", null: false
    t.integer "ttl_sec", null: false
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uuid"], name: "index_api_sessions_on_uuid", unique: true
  end

  create_table "container_proxies", force: :cascade do |t|
    t.integer "container_id"
    t.integer "proxy_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "containers", force: :cascade do |t|
    t.string "container_id"
    t.integer "status"
    t.string "ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "program_containers", force: :cascade do |t|
    t.integer "program_id"
    t.integer "container_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "program_resources", force: :cascade do |t|
    t.integer "program_id"
    t.integer "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.string "image_id"
    t.string "icon_path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "proxies", force: :cascade do |t|
    t.integer "external_port"
    t.integer "internal_port"
    t.string "internal_ip"
    t.integer "proto"
    t.integer "proxy_type"
    t.integer "ttl_sec"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_port"], name: "index_proxies_on_external_port", unique: true
  end

  create_table "resources", force: :cascade do |t|
    t.string "path"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["path"], name: "index_resources_on_path", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "api_sessions", "users"
  add_foreign_key "container_proxies", "containers"
  add_foreign_key "container_proxies", "proxies"
  add_foreign_key "program_containers", "containers"
  add_foreign_key "program_containers", "programs"
  add_foreign_key "program_resources", "programs"
  add_foreign_key "program_resources", "resources"
end
